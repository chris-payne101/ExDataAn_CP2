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

# Use aggregate function to aggregate emissions by year
emissionsByYear <- aggregate(NEI$Emissions,by=list(Category=NEI$year),FUN=sum)

##################################################################
## Step 4
## Create required png file
##################################################################

# open png file for writing
png("plot1.png")

# create bar plot using base system
barplot(height=emissionsByYear$x,names.arg=emissionsByYear$Category,
     xlab="Year",ylab="PM2.5 Emissions (tons)",
     main="Total PM2.5 Emission for 1999, 2002, 2005, and 2008")
# close device to write png file
dev.off()