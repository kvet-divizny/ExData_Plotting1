library(tidyverse)
library(lubridate)

if (!dir.exists("./data")) {dir.create("./data")}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              "./data/HPC.zip")
unzip("./data/HPC.zip", "household_power_consumption.txt", exdir = "./data")

# read data
household_power_consumption <- read_csv2("./data/household_power_consumption.txt", na = "?")

household_power_consumption <- household_power_consumption %>%
  mutate(Time = as.character(Time),
         Global_active_power = as.numeric(Global_active_power),
         Global_reactive_power = as.numeric(Global_reactive_power),
         Voltage = as.numeric(Voltage),
         Global_intensity = as.numeric(Global_intensity),
         Sub_metering_1 = as.numeric(Sub_metering_1),
         Sub_metering_2 = as.numeric(Sub_metering_2),
         Sub_metering_3 = as.numeric(Sub_metering_3)) %>% 
  unite("Datetime", Date, Time, sep = " ") %>% 
  mutate(Datetime = dmy_hms(Datetime))

household_power_consumption_filtered <- household_power_consumption %>% 
  filter(Datetime >= dmy("1. 2. 2007") & Datetime < dmy("3. 2. 2007"))

# make a plot

png("Plot_4.png", width = 480, height = 480, units = "px")


par(mfrow = c(2,2))
plot(household_power_consumption_filtered$Datetime, household_power_consumption_filtered$Global_active_power,
     type = "l", xlab = "", ylab = "Global Active Power")

plot(household_power_consumption_filtered$Datetime, household_power_consumption_filtered$Voltage,
     type = "l", xlab = "datetime", ylab = "Voltage")

plot(household_power_consumption_filtered$Datetime, household_power_consumption_filtered$Sub_metering_1,
     type = "l", ylab = "Energy Sub Metering", xlab = "")
lines(household_power_consumption_filtered$Datetime, household_power_consumption_filtered$Sub_metering_2,
      col = "red")
lines(household_power_consumption_filtered$Datetime, household_power_consumption_filtered$Sub_metering_3,
      col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1)

plot(household_power_consumption_filtered$Datetime, household_power_consumption_filtered$Global_reactive_power,
     type = "l", xlab = "datetime", ylab = "Global_reactive_power")

dev.off()
