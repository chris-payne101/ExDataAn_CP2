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
if (!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")) {
  unzip(dataDestination)
}

##################################################################
## Step 2 
## Read in the RDS Files
##################################################################

NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

##################################################################
## Step 3
## Process data so that a plot can be created
##################################################################

# load dplyr library to manipulate the dataframe
library(dplyr)
# subset the data.frame on fips for Baltimore (24510) and type (ON-ROAD)
baltiNEI <- subset(NEI, fips == "24510")
baltiNEI <- subset(baltiNEI, type == "ON-ROAD")
# use dplyr to reshape data (grouping by year and type)
baltiNEI2 <- baltiNEI %>% group_by(year) %>% summarize_at(vars(Emissions),sum)

# subset the data.frame on fips for LA (06037) and type (ON-ROAD)
laNEI <- subset(NEI, fips == "06037")
laNEI <- subset(laNEI, type == "ON-ROAD")
# use dplyr to reshape data (grouping by year and type)
laNEI2 <- laNEI %>% group_by(year) %>% summarize_at(vars(Emissions),sum)


##################################################################
## Step 4
## Create required png file
##################################################################


# open png file for writing
png("plot6.png",width=880, height=480)
# Create 1x2 plot canvas
par(mfrow = c(1,2))
# stop R printing number in scientific notation
options(scipen=999)
# create plots
barplot(names.arg=laNEI2$year,height=laNEI2$Emissions,
        xlab="Year",ylab="PM2.5 Emissions (tons)",
        ylim=c(0,5000),
        main="LA Vehicle Emissions\n from 1999 to 2008")
barplot(names.arg=baltiNEI2$year,height=baltiNEI2$Emissions,
        xlab="Year",ylab="PM2.5 Emissions (tons)",
        ylim=c(0,5000),
        main="Baltimore Vehicle Emissions\n from 1999 to 2008")


# close device to write png file
dev.off()