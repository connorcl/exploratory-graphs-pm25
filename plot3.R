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

## Create dataframe with records of total emissions, type and year
year_type_totals <- with(nei_baltimore, tapply(Emissions, list(year, type), sum))
year_type_totals <- data.frame(
    Emissions = as.numeric(year_type_totals),
    Type = rep(colnames(year_type_totals), each = 4),
    Year = as.integer(rep(rownames(year_type_totals)), times = 4)
)

## Create line chart, saving to a png file
library(ggplot2)
png("plot3.png")
ggplot(year_type_totals, aes(Year, Emissions, color = Type)) + 
    geom_line() + 
    geom_point() +
    xlab("") +
    ylab("PM2.5 Emissions (Tons)") +
    ggtitle(expression("PM2.5 Emissions in Baltimore City by Type"))
dev.off()