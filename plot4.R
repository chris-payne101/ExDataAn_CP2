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
SCC <- readRDS("Source_Classification_Code.rds")

##################################################################
## Step 3
## Process data so that a plot can be created
##################################################################

# The EPA SCC database is located online here: https://ofmpub.epa.gov/sccwebservices/sccsearch/
# You need to search through the various levels to find where Coal & Combustion occur
# Now you create logical vectors for SCC rows containing "Coal" & "Combustion"
combustion <- grepl("[cC]ombustion",SCC$SCC.Level.One)
coal <- grepl("[cC]oal",SCC$SCC.Level.Three)
# from  logical vectors create data.frame with SCC values corresponding to logical vector
sccCoal <- data.frame(as.character(SCC[coal & combustion,"SCC"]))
# add colname for merge to work
colnames(sccCoal) <- c("SCC")
# merge NEI and sccCoal (only merge where rows on both sides)
myMerge <- merge(NEI,sccCoal,by="SCC")
# Use aggregate function to aggregate emissions by year
emissionsByYear <- aggregate(myMerge$Emissions,by=list(Category=myMerge$year),FUN=sum)

##################################################################
## Step 4
## Create required png file
##################################################################

# open png file for writing
png("plot4.png")
# stop R printing number in scientific notation
options(scipen=999)
# create bar plot using base system
barplot(names.arg=emissionsByYear$Category,height=emissionsByYear$x,
     xlab="Year",ylab="PM2.5 Emissions (tons)",
     main="US Coal combustion-related PM2.5 Emissions from 1999–2008")
# close device to write png file
dev.off()