# Load libraries
library(dplyr)
library(ggplot2)

# Read dataset - fully featured - created by nn_boe_only_server.R
df <- readRDS(file = "dsAllWellsFullyFeatured.rds")

# How many NA in THP
df[df$thp == 0.00,"thp"] <- NA
df <- df[complete.cases(df),]

# Create single dataframe on 1 well
df <- df %>% group_by(uwi) %>% filter(uwi == 442) %>% 
  mutate(date = Sys.Date() + dop) %>% select(uwi, date, oil) %>% ungroup()

ds <- df$date
y <- df$oil

df <- data_frame(ds, y) 

head(df)

qplot(ds, y, data=df)

# Forecasting with Prophet
library(prophet)
m <- prophet(df)

m

# Prediction on 180 days in the future
future <- make_future_dataframe(m, periods = 180)
tail(future)
forecast <- predict(m , future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

# Plot Forecast
plot(m, forecast)
