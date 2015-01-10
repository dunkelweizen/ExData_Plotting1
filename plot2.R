# Download and process data
if (!file.exists('power_data_subset.txt')){
  # download zipped data
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                'exdata_data_household_power_consumption.zip',
                mode='wb')
  # extract data from zip file
  # here we read in the date and time columns as character, and the rest
  # as numerics
  dat <- read.table(unz('exdata_data_household_power_consumption.zip',
                        'household_power_consumption.txt'),header=T,sep=';',
                      colClasses =c(rep("character",2),rep("numeric",7)),
                      na.strings="?")
  
  # construct a datetime column
  dt <- strptime(paste(dat[,1],dat[,2]),format="%d/%m/%Y %H:%M:%S",tz="GMT")
  dat2 <- cbind(dat,dt)
  # and process the date and time columns separately
  dat2$Date <- as.Date(dat2$dt)
  dat2$Time <- strptime(dat[,2],format="%H:%M:%S",tz="GMT")
  
  # subset the data to the relevant dates
  dat_subset <- subset(dat2,dat2$Date=='2007-02-01' | dat2$Date=='2007-02-02')
  # and save the smaller dataset
  write.table(dat_subset,file='power_data_subset.txt',sep=";",row.names=F)
} else { # just read in the smaller dataset if it's already there...
  dat_subset <- read.table('power_data_subset.txt',sep=';',header=T,
                           colClasses=c("Date",
                                        "character",
                                        rep("numeric",7),
                                        "character"))
  # Time and datetime column formats...
  dat_subset$Time=strptime(substr(dat_subset$Time,12,19),
                           format="%H:%M:%S",tz="GMT")
  dat_subset$dt=strptime(dat_subset$dt,format="%Y-%m-%d %H:%M:%S",tz="GMT")
}
# 2nd plot...
png(file="plot2.png")
# draw the axes first
plot(dat_subset$dt,
     dat_subset$Global_active_power,
     type = "n",
     ylab="Global Active Power (kilowatts)",
     xlab="")
# then draw the lines
lines(dat_subset$dt,
      dat_subset$Global_active_power)
dev.off()
