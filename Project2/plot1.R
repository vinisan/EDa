# Load required packages
library(dplyr)

# Load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Using the base plotting system, make a plot showing the total PM2.5 emission from all
# sources for each of the years 1999, 2002, 2005, and 2008.
# Question: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

# sum the emission across all sources for each year
groupEmissions <- NEI %>% 
  group_by(year) %>% 
  summarise(num_Observations = length(Emissions),
            Emissions = sum(Emissions))

# A basic plot of x = emissions; y = year, dashed line = rough trend over time; 
# plot the total number of observations (x) for each year (y)
png("plot1.png", width = 480, height = 640)
par(mfrow = c(2, 1))
with(groupEmissions, {
  plot(year, Emissions, col = "red", 
       main = "Total emissions/year")
  lines(year, Emissions, lty = 8)
  plot(year, num_Observations, col = "red", 
       main = "Number of observations/year")
  lines(year, num_Observations, lty = 8)
})
dev.off()

# Observation: Number of observations increasing each year, emissions decreasing. 
# Inference: increased vigilance in monitoring emissions reduced total emissions from 1999 to 2008.
# This inference assumes no other factor contributed towards decreased emission