### Create a line chart of each type of emission in Baltimore City over time

## Download and extract data if necessary
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destfile <- "NEI_data.zip"
nei_filename <- "summarySCC_PM25.rds"
scc_filename <- "Source_Classification_Code.rds"
if(!file.exists(destfile)) {
    download.file(url = url, destfile = destfile, method = "curl")
    unzip(destfile)
}
if(!file.exists(nei_filename) | !file.exists(scc_filename)) {
    unzip(destfile)
}

## Load data
nei <- readRDS(nei_filename)
scc <- readRDS(scc_filename)

## Subset data to include only Baltimore City
nei_baltimore <- subset(nei, fips == "24510")

## Calculate total emissions by type and year
year_type_totals <- aggregate(Emissions ~ year + type, nei_baltimore, sum)

## Create line chart, saving to a png file
library(ggplot2)
png("plot3.png")
ggplot(year_type_totals, aes(year, Emissions, color = type)) + 
    geom_line() + 
    geom_point() +
    xlab("") +
    ylab("PM2.5 Emissions (Tons)") +
    ggtitle(expression("PM2.5 Emissions in Baltimore City by Type"))
dev.off()