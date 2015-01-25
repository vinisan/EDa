# Load required packages
library(dplyr)
library(ggplot2)

# Load the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 5. How have emissions from motor vehicle sources changed from 1999???2008 in
# Baltimore City?

# Use grep to identify all motor vehicle sources, as indicated by the term
# "mobile," and subset the SCC table
mobileSource <- grep("mobile", tolower(SCC$SCC.Level.One))
mobileFinal <- SCC[mobileSource, ]

# Use dplyr to do: 
# i. filter observations to only include mobile sources and observations in Baltimore (based on fips code); 
# ii. log-transform emissions values (used 1 to avoid -Inf as transformed values); 
# iii. calculate total emissions for each year
mobileBaltimore <- NEI %>%
  filter(SCC %in% mobileFinal$SCC, fips == "24510") %>%
  mutate(Emissions = log10(Emissions + 1)) %>%
  group_by(year) %>%
  mutate(total_Emissions = sum(Emissions))

# Creatd boxplots to show the median, 75th percentile, and 25th  percentile for each year; 
# fitted a basic linear regression line to estimate the trend

png("plot5.png", width = 480, height = 480)
ggplot(mobileBaltimore, aes(factor(year), Emissions)) +
  geom_boxplot(aes(fill = total_Emissions)) + 
  geom_smooth(method = "lm", aes(group = 1), 
              colour = "red", size = 1) + theme_bw()
dev.off()

# Observation and inference: linear regression line indicates, motor vehicle 
# sources in Baltimore decreased in emissions from 1999 to 2008; 