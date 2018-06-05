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

## Subset data to include only motor-vehicle sources
## in Baltimore City
nei_motor_baltimore <- subset(nei, type == "ON-ROAD" & fips == "24510")

## Create plot
emissions <- with(nei_motor_baltimore, tapply(Emissions, year, sum))
png("plot5.png")
barplot(emissions,
        col = "burlywood2", 
        main = expression("PM"[2.5]*" Emissions from Motor Vehicles in Baltimore City"),
        ylab = expression("PM"[2.5]*" Emissions (Tons)"))
dev.off()