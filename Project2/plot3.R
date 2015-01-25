# Load required packages
library(dplyr)
library(ggplot2)

# Load the data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# Question: Four types of sources indicated by the type (point, nonpoint,  onroad, nonroad) variable, which of these 
# four sources have seen decreases  in emissions from 1999???2008 for Baltimore City? Which have seen increases in
# emissions from 1999???2008? Use the ggplot2 plotting system to make a plot answer this question.

# filtering observations to only include Baltimore ( fips code = 24510)
baltimore <- NEI %>% 
  filter(fips == "24510") 

# Histogram of emissions values for Baltimore, shows emission values are skewed towards lower values (plot not included) 
ggplot(bmoreEmissions, aes(Emissions)) + 
  geom_histogram() + 
  theme_bw()



# With dplyr  
#(1) log-transformed emissions values (after  adding 1 to avoid -Inf values when transforming zeros); 
# (2) calculated the  total emissions for each year & type combination

baltimoreSummary <- baltimore %>%
  mutate(Emissions = log10(Emissions + 1)) %>%
  group_by(year, type) %>%
  mutate(total_Emissions = sum(Emissions))

# Created boxplots of the data, showing the median, 75th percentile, and 25th  percentile for each year; 
# for trend, linear regression was fitted and the line was plotted; 
# each type of emission is plotted a separate panel; 
# fill color of box plots were scaled according to the total emissions
png("plot3.png", width = 640, height = 640)
ggplot(baltimoreSummary, aes(factor(year), Emissions)) +
  geom_boxplot(aes(fill = total_Emissions)) +
  geom_smooth(method = "lm", aes(group = 1),
              colour = "red", size = 1) + 
  facet_wrap(~ type, scales = "free") + theme_bw()
dev.off()

# Observation and inference: linear regression line indicates, each source
# type showed a decrease in emissions from 1999 to 2008. 
# Based on median, 
# i. non-road sources showed only a very modest decrease;
# ii. non-point sources increased in 2002 and 2005  before decreasing in 2008; 
# iii. point sources decreased, increased, and then decreased again. 
# Based on total emissions, both non-point and point sources showed a relative increase in 2008 compared to 1999. 
# On-road sources decreased rather modestly from 1999-2008 across all measures.