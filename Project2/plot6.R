# Load required packages
library(dplyr)
library(ggplot2)

# Load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
# sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor
# vehicle emissions?

# Use grep to extract motor vehicle sources and subset the SCC table
mobileSource <- grep("mobile", tolower(SCC$SCC.Level.One))
mobileFinal <- SCC[mobileSource, ]

# Using dplyr to do: 
# i. filter observations to only include mobile sources and observations in Baltimore and Los Angeles County (based on fips code);
# ii. log-transform emissions values (used 1 to avoid -Inf as transformed values); 
# iii. calculate total emissions for each year-location combination
mobileEComp <- NEI %>%
  filter(SCC %in% mobileFinal$SCC, fips %in% c("24510", "06037")) %>%
  mutate(Emissions = log10(Emissions + 1)) %>%
  group_by(year, fips) %>%
  mutate(total_Emissions = sum(Emissions))

# Creatd boxplots to show the median, 75th percentile, and 25th  percentile for each year; 
# fitted a basic linear regression line to estimate the trend
png( "plot6.png", width = 640, height = 480)
ggplot(mobileEComp, aes(factor(year), Emissions)) +
  geom_boxplot(aes(fill = total_Emissions)) + 
  geom_smooth(method = "lm", aes(group = 1), 
              colour = "red", size = 1) +
  facet_wrap(~ fips, scales = "free") + theme_bw()
dev.off()

# Observation: linear regression indicatess that motor vehicle sources show a larger decrease in emissions from 1999 to 2008 for both Baltimore and
# Los Angeles; 