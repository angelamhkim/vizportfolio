#load libraries
library(dplyr)
library(plotly)
library(htmlwidgets)

#open the data
dat <- read.csv("approval.ratings.csv")

#format date
start <- as.Date("2001-01-04")
end <- as.Date("2019-09-04")
forced_start <- as.Date(paste0(format(start, "%Y-%m"), "-01"))
forced_end <- as.Date(paste0(format(end, "%Y-%m"), "-01"))
seq_dates <- seq.Date(forced_start, forced_end, by = "month")
dat$X <- seq_dates


p <- plot_ly(dat, x=~X)%>%
  add_trace(y=~WP, name="Washington Post",
            type='scatter', 
            mode='lines', 
            marker=list(color='black'))%>%
  add_trace(y=~Fox, name="Fox News", 
            type='scatter',
            mode='lines',
            marker=list(color='rgba(194,0,23,1)'))%>%
  rangeslider()%>%
  layout(title="Presidential Approval Rating From 2001 to 2019",
         hovermode='compare', 
         xaxis=list(title="Date"),
         yaxis=list(title="Approval Rating (%)"))

htmlwidgets::saveWidget(as.widget(p), "graph.html")