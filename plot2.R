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

baltiNEI <- subset(NEI, fips == "24510")
emissionsByYear <- aggregate(baltiNEI$Emissions,by=list(Category=baltiNEI$year),FUN=sum)

##################################################################
## Step 4
## Create required png file
##################################################################

png("plot2.png")
options(scipen=999)
plot(emissionsByYear$Category,emissionsByYear$x,
     xlab="Year",ylab="Emissions (tons)",
     main="Total Baltimore PM2.5 Emission for 1999, 2002, 2005, and 2008",
     xaxt="n",type="l")
points(emissionsByYear$Category,emissionsByYear$x)
axis(1,at=c(1999,2002,2005,2008),labels=c("1999","2002","2005","2008"))
dev.off()