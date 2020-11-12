url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

dir <- "./data2"
file <- "data2.zip"
filename <- paste(dir, "/", file, sep = "")

# Creates folder 'data' when non-existent and downloads the required data
if (!file.exists(filename)) {
  dir.create(dir)
  download.file(url = url, destfile = file)
}

# Unzips the required data into 'data'
utils::unzip(zipfile = file, exdir = dir)

# Imports data
household <- read.table(file = paste0(dir, "/household_power_consumption.txt"), sep = ";", dec = ".", header = T)

head(household)
class(household$Date)

# Convert factor date to data format
household$Date2 <- as.Date(strptime(household$Date, format = "%d/%m/%Y"))
household$DateTime <- as.POSIXct(paste(household$Date, household$Time), format="%d/%m/%Y %H:%M:%S")

class(household$Date2)

# Subset data by given data
subset <- household[household$Date2 >= "2007-02-01 00:00:00" & household$Date2 <= "2007-02-02 00:00:00", ]

# Plotting
subset$Sub_metering_1 <- as.numeric(as.character(subset$Sub_metering_1))
subset$Sub_metering_2 <- as.numeric(as.character(subset$Sub_metering_2))
subset$Sub_metering_3 <- as.numeric(as.character(subset$Sub_metering_3))

png(filename = "plot3.png") #width + height are by default 480 x 480

plot(x = subset$DateTime, y = subset$Sub_metering_1, type = "l", col="black",
     ylab = "Energy Sub Metering", xlab = "", main = "Global Active Power",
     ylim = c(0,40))

lines(subset$DateTime, as.numeric(subset$Sub_metering_2), col="red", type = "l")
lines(subset$DateTime, as.numeric(subset$Sub_metering_3), col="blue", type = "l")

legend("topright", legend = c("Sub_metering_1", "Sub_metering_2",
                              "Sub_metering_3"), col = c("black", "red", "blue"), lwd = 1, cex = 0.5)

dev.off()