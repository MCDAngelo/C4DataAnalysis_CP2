# Have total emissions from PM2.5 decreased in the United States
# from 1999 to 2008? Using the base plotting system, make a plot
# showing the total PM2.5 emission from all sources for each of
# the years 1999, 2002, 2005, and 2008.

#First need to read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Check data, including unique years to confirm only 1999, 2002, 
#2005, and 2008 are included
head(NEI)
str(NEI)
unique(NEI$year)

#load plyr library
library(plyr)
#create sums of overall emissions by year using ddply
#divide sum by 1000 to convert to kilotons
total_emissions <- ddply(NEI, .(year), summarise, 
                         emissions = sum(Emissions)/1000)


png(file = "plot1.png") #create png file named plot1.png

#make graph that will be saved to the png file
plot1 <- barplot(total_emissions$emissions, 
        las = 2, xlab = "Year", ylab = "Total PM 2.5 Emissions in Kilotons",
        main = "Total PM 2.5 Emissions from All Sources by Year")
axis(1, at = plot1, labels = total_emissions$year) #add labels to x-axis

dev.off()
