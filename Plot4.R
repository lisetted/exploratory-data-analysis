#check if data file exists already, if not download
if (!file.exists(filename)){
  file1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(file1, filename, method="curl")
}  
if (!file.exists("power_consumption")) { 
  unzip(filename) 
}


#read in data
power <- read.table("household_power_consumption.txt", header= TRUE, sep =";",  na.strings=c("NA", "?"))
summary(power$Date)
library(dplyr)
library(lattice)

#we are only using 2 dates- properly format date and time
temp <- filter(power , Date== c("2/1/2007", "2/2/2007"))
data <- mutate (temp, Date= as.Date(Date, format="%m/%d/%Y") )
data$time <- strptime(data$Time, "%H:%M:%S")

datetime <- paste(as.Date(data$Date), data$Time)
data$Datetime <- as.POSIXct(datetime)

png("plot4.png", width=480, height=480)

#set 2 ros and 2 columns
par(mfrow=c(2,2))

#first plot (row 1, col 1)
plot(data$Datetime,data$Global_active_power,
     type="l"
     ,ylab ="Global Active Power (kilowats)", xlab="")

#second  plot (row 1 col 2)
plot(data$Datetime,data$Voltage,
     type="l", 
     ,ylab ="Voltage", xlab="datetime")


#third plot (row 2, col 1)
plot(data$Datetime ,data$Sub_metering_3 ,
     type="l"  
     ,ylab ="Energy sub metering", col="black")
lines(data$Datetime ,data$Sub_metering_2,type="l",  col="blue")
lines(data$Datetime ,data$Sub_metering_1,type="l", col="red")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=1, lwd=2.5, col=c("black", "red", "blue"))


#fourth plot (row 2 col 2)
plot(data$Datetime,data$Global_reactive_power,
     type="l"
     ,ylab ="Global reactive Power (kilowats)", xlab= "datetime")

dev.off()
