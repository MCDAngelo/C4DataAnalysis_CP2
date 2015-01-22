# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999–2008?

#First need to read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset NEI data to select only coal combustion related sources
#First used grep to get names in Short.Name and EI.Sector columns
#that contain coal or Coal
coal_sn <- grep(" [cC]oal", SCC$Short.Name, value = TRUE)
coal_ei <- grep(" [cC]oal", SCC$EI.Sector, value = TRUE)

#Second created a subset of the SCC dataframe containing the rows
#that are identified as having coal in the name from above
coal_SCC_data <- subset(SCC, Short.Name %in% coal_sn | EI.Sector %in% coal_ei)

#Create a list of SCC values from the subset to use in filtering
#NEI file
coal_SCC <- unique(coal_SCC_data [,1])

#Subset NEI with the list of coal SCC values
coal_EI <- subset(NEI, SCC %in% coal_SCC)

#Load plyr library
library(plyr)

#create sums of overall coal emissions by year using ddply
#divide sum by 1000 to convert to kilotons
coal_emissions <- ddply(coal_EI, .(year), summarise,
                        emissions = sum(Emissions)/1000)

#Load ggplot2 library
library(ggplot2)

#create plot with ggplot
plot4 <- ggplot(coal_emissions, aes(year, emissions))
plot4 + geom_point(size = 4, alpha = 0.7) + 
        geom_line(alpha = 0.7) +
        ylab("Total PM 2.5 Emissions in Kilotons") +
        xlab("Year") +
        ggtitle("Total PM 2.5 Emissions from Coal-related Combustion") +
        theme_bw()


ggsave("Plot4.png")
