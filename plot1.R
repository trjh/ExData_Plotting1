#!/opt/local/bin/Rscript

#
# Create a histogram of the Global Active Power consumption, in kilowatts, on
# the dates 2007-02-01 and 2007-02-02,
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

# might have also been useful to include:
# set '?' values to 'NA'
#   na.strings = '?',
#   colClasses=c('character','character','numeric','numeric',
#   'numeric','numeric','numeric','numeric','numeric'),

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

#
# interesting thing done by @goestreicher, but i haven't tested to see how it
# changes or improves the minute accuracy of emulation of the 'grading graphs'
#
# oldLocale = Sys.getlocale( category = "LC_TIME" )
## set a default one for the duration of this script. Using "C" seems to
## yield the  best results.
#Sys.setlocale( category = "LC_TIME", locale = "C" )
#
## then at the end of the file, restore the locale
# Sys.setlocale( category = "LC_TIME", locale = oldLocale )

# open the PNG output file

png(filename = "plot1.png",
    width = 480, height = 480, units = "px")

# we could alter margins here -- thought I had to do so to match the image
# shown in the assignment.  However, that one is 504x504 with margins
# unaltered from the default.  We'll set the defaults here just to be sure, to
# be sure.

par(mar = c(5, 4, 4, 2))

# construct our plot

hist(as.numeric(power$Global_active_power), col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)"
)

# another interesting method
# hist.info <- hist(power$Global_active_power)
# plot(hist.info, col="red",
#     xlim=c(0,6),ylim=c(0,1200),
#     xlab="Global Active Power (kilowatts)",main="Global Active Power")

# close the PNG file -- plot will now be written

dev.off()
