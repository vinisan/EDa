#Reading the data
library(dplyr)
library(lubridate)
raw.Data<-read.csv("household_power_consumption.txt", sep = ";", na.strings = c("?"))

#greping the time stamps and subsetting the data
Raw2<-grep("^2/2/2007",raw.Data$Date )
Raw1<-grep("^1/2/2007",raw.Data$Date )
sub.Raw2<-as.data.frame(raw.Data[Raw2,])
sub.Raw1<-as.data.frame(raw.Data[Raw1,])
head(sub.Raw1)
head(sub.Raw2)
#comibing the data into one dataframe
main.Data<-rbind(sub.Raw1, sub.Raw2)
main.Data <- mutate(main.Data, dateTime = dmy_hms(paste(Date, Time)))
#making the plot
par (bg = "transparent")
png("plot4.png")
par (bg = "transparent")
par(mfrow = c(2, 2), bg = "transparent")
with(main.Data, {
  # panel 1 (top left)
  plot(dateTime, Global_active_power,
       type = "n",
       ylab = "Global Active Power",
       xlab = "")
  lines(dateTime, Global_active_power)
  
  # panel 2 (top right)
  plot(dateTime, Voltage,
       type = "n",
       ylab = "Voltage")
  lines(dateTime, Voltage)
  
  # panel 3 (bottom left)
  plot(dateTime, Sub_metering_1,
       type = "n",
       ylab = "Energy sub metering",
       xlab = "")
  lines(dateTime, Sub_metering_1)
  lines(dateTime, Sub_metering_2, col = "red")
  lines(dateTime, Sub_metering_3, col = "blue")
  legend("topright", bty = "n", lty = 1, col = c("black", "red", "blue"),
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  # panel 4 (bottom right)
  plot(dateTime, Global_reactive_power,
       type = "n")
  lines(dateTime, Global_reactive_power)
})
dev.off()