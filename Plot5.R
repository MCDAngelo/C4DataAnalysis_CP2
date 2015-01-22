# How have emissions from motor vehicle sources 
# changed from 1999–2008 in Baltimore City? 

#First need to read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset NEI data to select only motor vehicle sources
#First used grep to get names in EI.Sector columns
#that contain Vehicles
vehicles_ei <- grep(" [vV]ehicles", SCC$Short.Name, value = TRUE)

#Second created a subset of the SCC dataframe containing the rows
#that are identified as having vehicle in the name from above
veh_SCC_data <- subset(SCC, Short.Name %in% vehicles_ei)

#Create a list of SCC values from the subset to use in filtering
#NEI file
veh_SCC <- unique(veh_SCC_data [,1])

#Subset NEI with the list of vehicle SCC values
#& the Baltimore City fips value
veh_BC_EI <- subset(NEI, SCC %in% veh_SCC & fips == "24510")

#Load plyr library
library(plyr)

#create sums of overall vehicle emissions by year using ddply
#divide sum by 1000 to convert to kilotons
veh_BC_emissions <- ddply(veh_BC_EI, .(year), summarise,
                        emissions = sum(Emissions)/1000)

#Load ggplot2 library
library(ggplot2)

#create plot with ggplot
plot5 <- ggplot(veh_BC_emissions, aes(year, emissions))
plot5 + geom_point(size = 4, alpha = 0.7) + 
        geom_line(alpha = 0.7) +
        ylab("Total PM 2.5 Emissions in Kilotons") +
        xlab("Year") +
        ggtitle("PM 2.5 Emissions from Motor Vehicles in Baltimore City") +
        theme_bw()


ggsave("Plot5.png")
