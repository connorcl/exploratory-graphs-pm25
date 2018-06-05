### Creates a barplot of US PM2.5 emissions from coal combustion during each year

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

## Subset data to include only coal-combustion sources
scc_coal <- as.character(scc[grep("Fuel Comb.*[Cc]oal", scc$EI.Sector),"SCC"])
nei_coal <- subset(nei, SCC %in% scc_coal)

## Calculate total PM2.5 emissions for each year
emissions <- with(nei_coal, tapply(Emissions, year, sum))

## Create barplot, saving to a png file
png("plot4.png")
barplot(emissions,
        col = "burlywood2", 
        main = "US PM2.5 Emissions from Coal Combustion",
        ylab = "PM2.5 Emissions (Tons)")
dev.off()