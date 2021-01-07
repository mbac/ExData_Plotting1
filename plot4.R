## Data Preparation

# Get data
if (!file.exists("data/household_power_consumption.txt")) {
    if (!dir.exists("data/"))
        dir.create("data")
    download.file(
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
        "data/main.zip"
    )
    # Unzip—be advised that by defauly this gets extracted into working dir
    unzip("data/main.zip", exdir = "data")
}

# Read in data
if (!exists("data")) {
    # Caught a couple of lines with '?' instead of empty cells, which caused
    # problems with type conversion. Use na.strings arg.
    bigdata <-
        fread("data/household_power_consumption.txt", na.strings = "?")

    # Select the 2 dates requested by the exercise
    data <- bigdata[Date %like% "^[12]{1}\\/2\\/2007", ]

    # Cast the now-leaner data set into lubdridate-made POSIX. Note that it may be more concise to join Date and Time into a single vector, using paste.
    data[, DateTime := lubridate::dmy_hms(paste(Date, Time, sep = " "))]

    # Free up memory
    remove(bigdata)
}

# Four plots in grid
par(mfrow = c(2, 2))

# Plot A = Plot 1
with(data, plot(
    Global_active_power ~ DateTime,
    type = "l",
    ylab = "Global Active Power (kilowatts)"))

# Plot B
with (data, plot(
    Voltage ~ DateTime,
    type = "l"
))

# Plot C = Plot 3
## Multivariate line graph over time
with(data, plot(
    Sub_metering_1 ~ DateTime,
    type = "l",
    ylab = "Energy sub metering"))

with(data, lines(Sub_metering_2 ~ DateTime, type = "l", col = "red"))
with(data, lines(Sub_metering_3 ~ DateTime, type = "l", col = "blue"))

# Plot D
with(data, plot(
    Global_reactive_power ~ DateTime,
    type = "l"
))

# Print PNG file
dev.print(  device = png,
            width = 480,
            height = 480,
            units = "px",
            file = 'plot4.png')
