# Load required packages
library(dplyr)

# Load the data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
#Use the base plotting system to make a plot answering this question.

# Sum the emission across all sources for each year, filtering observations to only include Baltimore ( fips code = 24510)
baltimore <- NEI %>% 
  filter(fips == "24510") %>% 
  group_by(year) %>%
  summarise(num_Observations = length(Emissions),
            Emissions = sum(Emissions))

# Created a basic scatter plot of total emissions vs. year, with a dashed line
# showing rough trend over time; also, plot the total number of observations
# for each year
png("plot2.png", width = 480, height = 640)
par(mfrow = c(2, 1))
with(baltimore, {
  plot(year, Emissions, col = "red", 
       main = "Baltimore emissions/year")
  lines(year, Emissions, lty = 8)
  plot(year, num_Observations, col = "red", 
       main = "Number of observations/year")
  lines(year, num_Observations, lty = 8)
})
dev.off()

# Observation: from 1999 to 2008,the number of source-emissions observations has increased 
# the total emissions have clearly decreased from 1999 to 2008.
# Though the data show an increase in total emissions from 2002 to 2005, and it decreased again. however in 2008, it was lower
# than 1999.
# Inference: total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008
