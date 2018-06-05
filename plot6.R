### Creates a line chart showing PM2.5 emissions from motor vehicle sources
### in Baltimore City and Los Angeles County

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

## Subset data to include only motor vehicle emissions 
## in Baltimore City and Los Angeles County
nei_motor_baltimore_la <- subset(nei, 
                                 type == "ON-ROAD" & fips %in% c("24510", 
                                                                 "06037"))

## Create dataframe with records of total emissions, location and year
year_loc_totals <- with(nei_motor_baltimore_la,
                        tapply(Emissions, list(year, fips), sum))
colnames(year_loc_totals) <- c("Los Angeles County", "Baltimore City")
year_loc_totals <- data.frame(
    Emissions = as.numeric(year_loc_totals),
    Location = rep(colnames(year_loc_totals), each = 4),
    Year = as.integer(rep(rownames(year_loc_totals), times = 2))
)

## Create line chart, saving to a png file
library(ggplot2)
png("plot6.png")
ggplot(year_loc_totals, aes(Year, Emissions, color = Location)) + 
    geom_line() + 
    geom_point() + 
    xlab("") +
    ylab("PM2.5 Emissions (Tons)") +
    ggtitle("PM2.5 Emissions from Motor Vehicle Sources")
dev.off()