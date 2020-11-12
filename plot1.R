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
png(filename = "plot1.png") #width + height are by default 480 x 480

hist(as.numeric(subset$Global_active_power)/1000, col="red", 
     xlab = "Global Active Power (kilowatts)", main = "Global Active Power", breaks=20)

dev.off()
