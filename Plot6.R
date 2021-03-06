# Compare emissions from motor vehicle sources in 
# Baltimore City with emissions from motor vehicle 
# sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater 
# changes over time in motor vehicle emissions?

#First need to read in the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Subset NEI data to select only motor vehicle sources
#First used grep to get names in EI.Sector columns
#that contain 'Vehicles'
vehicles_ei <- grep(" [vV]ehicles", SCC$Short.Name, value = TRUE)

#Second created a subset of the SCC dataframe containing the rows
#that are identified as having vehicle in the name from above
veh_SCC_data <- subset(SCC, Short.Name %in% vehicles_ei)

#Create a list of SCC values from the subset to use in filtering
#NEI file
veh_SCC <- unique(veh_SCC_data [,1])

#Subset NEI with the list of vehicle SCC values
#& the Baltimore City or LA fips value
veh_EI <- subset(NEI, 
                    SCC %in% veh_SCC & (fips == "24510" | fips == "06037"))

#Load plyr library
library(plyr)

#create sums of overall vehicle emissions by year using ddply
veh_emissions <- ddply(veh_EI, .(year, fips), summarise,
                       emissions = sum(Emissions))
#Add in variable with city names
veh_emissions$City <- rep(c("Los Angeles", "Baltimore City"),4)

#Load ggplot2 library
library(ggplot2)

#create plot with ggplot, but used facets to show the emissions
#separately for each city and with different scales for each one
#as LA had larger starting values and when plotted on the same scale
#the different starting values minimized the changes in Baltimore City
plot6 <- ggplot(veh_emissions, aes(year, emissions)) #, Group = City))
plot6 + geom_point(size = 4, alpha = 0.7) + #aes(color = City),
        geom_line(alpha = 0.7) +
        facet_grid(City~. ,scales ="free") +
        ylab("PM 2.5 Emissions") +
        xlab("Year") +
        ggtitle("PM 2.5 Emissions from Motor Vehicles in Baltimore City and Los Angeles") +
        theme_bw()

ggsave("Plot6.png")
