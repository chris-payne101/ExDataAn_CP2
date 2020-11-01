##################################################################
## Step 1
## Check for the existence of the required zip file, download if 
## absent and unzip
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
##################################################################

dataSource <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dataDestination <- "exdata_data_NEI_data.zip" 

# if dataDestination file doesn't exist download and unzip
if (!file.exists(dataDestination)) {
  download.file(dataSource,dataDestination)
}

# if summarySCC_PM25.rds doesn't exist unzip the file just downloaded
if (!file.exists("summarySCC_PM25.rds")) {
  unzip(dataDestination)
}

##################################################################
## Step 2 
## Read in the RDS Files
##################################################################

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##################################################################
## Step 3
## Process data so that a plot can be created
##################################################################
library(dplyr)
baltiNEI <- subset(NEI, fips == "24510")
baltiNEI2 <- baltiNEI %>% group_by(year,type) %>% summarize_at(vars(Emissions),sum)

##################################################################
## Step 4
## Create required png file
##################################################################

library(ggplot2)
png("plot3.png")
options(scipen=999)
myplot <- ggplot(data=baltiNEI2, aes(x = year, y = Emissions,color=factor(type))) +
       geom_line() + geom_point(size=4) +
       labs(title = "Baltimore PM2.5 Emission by Type for 1999, 2002, 2005, and 2008"
              ,x = "Year", y = "Emissions (tons)", color = "Type")
  
print(myplot)
dev.off()