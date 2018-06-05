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

## Subset data to include only coal-related sources
scc_coal <- scc[grep("[Cc]oal|[Ll]ignite", scc$SCC.Level.Three),"SCC"]
nei_coal <- subset(nei, SCC %in% scc_coal)

## Create plot
emissions <- with(nei_coal, tapply(Emissions, year, sum))
png("plot4.png")
barplot(emissions,
        col = "burlywood2", 
        main = expression("US PM"[2.5]*" Emissions from Coal Combustion-Related Sources"),
        ylab = expression("PM"[2.5]*" Emissions (Tons)"))
dev.off()