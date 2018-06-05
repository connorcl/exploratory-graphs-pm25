

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

## Transform data
year_type_totals <- with(nei, tapply(Emissions, list(year, type), sum))
transformed_data <- data.frame(
    Emissions = as.numeric(year_type_totals),
    Type = rep(colnames(year_type_totals), each = 4),
    Year = as.integer(rep(rownames(year_type_totals)), times = 4)
)

## Plot graph, saving to a png file
library(ggplot2)
png("plot3.png")
ggplot(transformed_data, aes(Year, Emissions, color = Type)) + 
    geom_line() + 
    geom_point() +
    xlab("") +
    ylab(expression("Total PM"[2.5]*" Emissions (Tons)")) +
    ggtitle(expression("Total PM"[2.5]*" Emissions Over Time by Type"))
dev.off()