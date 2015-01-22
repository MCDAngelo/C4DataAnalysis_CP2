# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these 
# four sources have seen decreases in emissions from 1999–2008 for 
# Baltimore City? Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

#First need to read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset NEI data to select only Baltimore City (fips == "24510")
BC_data <- subset(NEI, fips == "24510")

#Load plyr library
library(plyr)

#Create sums of overall emissions by year using ddply
#divide sum by 1000 to convert to kilotons
emissions_BC_type <- ddply(BC_data, .(year, type), summarise, 
                            emissions = sum(Emissions)/1000)

#Make year and type factor variables for plotting with ggplot
emissions_BC_type$year <- as.factor(emissions_BC_type$year)
emissions_BC_type$type <- as.factor(emissions_BC_type$type)

#Load ggplot2 library
library(ggplot2)

plot3 <- ggplot(emissions_BC_type, aes(year, emissions, group = type))
plot3 + geom_point(aes(color = type), size = 4, alpha = 0.7) + 
        geom_line(aes(color = type), alpha = 0.7) +
        ylab("Total PM 2.5 Emissions in Kilotons") +
        xlab("Year") +
        ggtitle("Total PM 2.5 Emissions in Baltimore City by Type") +
        theme_bw()


ggsave("Plot3.png")