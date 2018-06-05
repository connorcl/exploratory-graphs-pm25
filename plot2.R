### Creates a barplot showing PM2.5 emissions in Baltimore City for each year

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

## Calculate total PM25 emissions for each year
emissions <- with(nei_baltimore, tapply(Emissions, year, sum))

## Create barplot, saving to a png file
png("plot2.png")
barplot(emissions, 
        col = "burlywood2", 
        main = "Baltimore City PM2.5 Emissions by Year",
        ylab = "PM2.5 Emissions (Tons)")
dev.off()