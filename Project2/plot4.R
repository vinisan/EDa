# Load required packages
library(dplyr)
library(ggplot2)

# Load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 4. Across the United States, how have emissions from coal combustion-related
# sources changed from 1999???2008?

# Use grep to identify all coal sources and subset the SCC table
coalSource <- grep("coal", tolower(SCC$SCC.Level.Three))
coalFinal <- SCC[coalSource, ]

# Use dplyr to do: 
# i. filter observations to only include mobile sources and observations in Baltimore (based on fips code); 
# ii. log-transform emissions values (used 1 to avoid -Inf as transformed values); 
# iii. calculate total emissions for each year
coalEmission <- NEI %>%
  filter(SCC %in% coalFinal$SCC) %>%
  mutate(Emissions = log10(Emissions + 1)) %>%
  group_by(year) %>%
  mutate(total_Emissions = sum(Emissions))

# Creatd boxplots to show the median, 75th percentile, and 25th  percentile for each year; 
# fitted a basic linear regression line to estimate the trend

png("plot4.png", width = 480, height = 480)
ggplot(coalEmission, aes(factor(year), Emissions)) +
  geom_boxplot(aes(fill = total_Emissions)) + 
  geom_smooth(method = "lm", aes(group = 1), 
              colour = "red", size = 1) + theme_bw()
dev.off()

# Observation: linear regression line indicates, coal sources decreased in emissions from 1999 to 2008; 
# Based on total emissions, there is an increase for the period of 2002-2008 before decreasing in 2008.