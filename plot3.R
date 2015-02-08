#!/opt/local/bin/Rscript

#
# Create a line plot showing the three energy sub-metering levels
# (sub_metering_1, sub_metering_2, and sub_metering_3)
# (in watt-hour of active energy)
# on the dates 2007-02-01 and 2007-02-02,
# using data from the 
# Individual household electric power consumption Data Set 
# https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
#
# This code presumes that the data file, household_power_consumption.txt, is
# in the current directory
#
file <- "household_power_consumption.txt"

# only read in the lines we need, via pipe to the 'egrep' unix command
power <- read.table(
    pipe('egrep "^Date|^[12]/2/2007" household_power_consumption.txt'),
    sep=";",
    header=TRUE,
    stringsAsFactors = FALSE
    )

# ensure we've read what we expected to read
if (!identical(as.numeric(dim(power)), c(2880, 9))) {
    stop("expected dataset to have dimensions 2880 x 9")
}

# use the Date and Time variables to create a DateTime field with the
# appropriate class, useful in later # plots -- lazily via dplyr & lubridate

library(lubridate)
library(dplyr)
power <- tbl_df(power) %>%
	 mutate(datetime = dmy_hms(paste(Date,Time)))

# open the PNG output file

png(filename = "plot3.png",
    width = 480, height = 480, units = "px")

# we could alter margins here -- thought I had to do so to match the image
# shown in the assignment.  However, that one is 504x504 with margins
# unaltered from the default.  We'll set the defaults here just to be sure, to
# be sure.

par(mar = c(5, 4, 4, 2))

# construct our plot

with(power, {
    plot(datetime, Sub_metering_1, type="n",
	 ylab = "Energy sub metering", xlab = "")
    lines(datetime, Sub_metering_1)
    lines(datetime, Sub_metering_2, col="red")
    lines(datetime, Sub_metering_3, col="blue")
})

# add the legend

legend("topright", lty = 1, col = c("black", "blue", "red"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# close the PNG file -- plot will now be written

dev.off()
