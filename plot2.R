### Creates a barplot exploring whether total pm25 emissions in Baltimore City
### have decreased from 1999 to 2008

## Download and extract data
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

## Create barplot, saving to a png file
png("plot2.png")
# Create named vector of total emissions by year
emissions <- tapply(nei_baltimore$Emissions, nei_baltimore$year, sum)
# Plot graph
barplot(emissions, 
        col = "burlywood2", 
        main = expression("Baltimore City PM"[2.5]*" Emissions by Year"),
        ylab = expression("Total PM"[2.5]*" Emissions (Tons)"))
dev.off()