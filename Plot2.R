# Have total emissions from PM2.5 decreased in Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base 
# plotting system to make a plot answering this question.

#First need to read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset NEI data to select only Baltimore City (fips == "24510")
BC_data <- subset(NEI, fips == "24510")

#Load plyr library
library(plyr)

#create sums of overall emissions by year using ddply
#divide sum by 1000 to convert to kilotons
total_emissions_BC <- ddply(BC_data, .(year), summarise, 
                         emissions = sum(Emissions)/1000)

png(file = "plot2.png") #create png file named plot1.png

#make graph that will be saved to the png file
plot2 <- barplot(total_emissions_BC$emissions, 
                 las = 2, xlab = "Year", 
                 ylab = "Total PM 2.5 Emissions in Kilotons",
                 main = "Total PM 2.5 Emissions in \nBaltimore City by Year")
axis(1, at = plot2, labels = total_emissions_BC$year) #add labels to x-axis

dev.off()
