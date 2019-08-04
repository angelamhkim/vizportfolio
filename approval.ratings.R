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

#major events 
Bush <- list(
  x=dat$X[1],
  y=dat$WP[2],
  xref='x',yref='y',
  text=paste0("Bush takes office"),
  ax=0,ay=40
)

Sep11 <- list(
  x=dat$X[9],
  y=dat$WP[9],
  xref='x', yref='y',
  text=paste0("9/11"),
  ax=0, ay=-30
)

IraqWar <- list(
  x=dat$X[27],
  y=dat$WP[27],
  xref='x', yref='y',
  text=paste0("Iraq War"),
  ax=0, ay=-40
)

Katrina <- list(
  x=dat$X[56],
  y=dat$WP[56],
  xref='x',yref='y',
  text=paste0("Katrina"),
  ax=0,ay=-40
)

Obama <- list(
  x=dat$X[95],
  y=dat$WP[96],
  xref='x',yref='y',
  text=paste0("Obama elected"),
  ax=0,ay=-30
)

Recession <- list(
  x=dat$X[84],
  y=dat$WP[84],
  xref='x',yref='y',
  text=paste0("Recession starts"),
  ax=0,ay=-40
)

Obamacare <- list(
  x=dat$X[111],
  y=dat$WP[111],
  xref='x',yref='y',
  text=paste0("Obamacare"),
  ax=0,ay=-40
)

binLaden <- list(
  x=dat$X[125],
  y=dat$WP[125],
  xref='x',yref='y',
  text=paste0("bin Laden killed"),
  ax=0,ay=-40
)

gay <- list(
  x=dat$X[174],
  y=dat$WP[175],
  xref='x', yref='y',
  text=paste0("same sex marriage"),
  ax=0,ay=40
)

Trump <- list(
  x=dat$X[193],
  y=dat$Fox[194],
  xref='x',yref='y',
  text=paste0("Trump takes office"),
  ax=0,ay=-40
)

#update menus for buttons
updatemenus <- list(
  list(
    active=-1,
    type='buttons',
    direction='down',
    xanchor='right',
    yanchor='center',
    x=1.2,
    y=0.5,
    buttons=list(
      list(
        label="major events",
        method="update", 
        args=list(list(visible=c(TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE)), 
                  list(title="events",
                       annotations=list(c(),gay,Trump,Bush, Sep11, IraqWar,Katrina,Obama,Recession,Obamacare,binLaden)))
      ),
      list(
        label="reset",
        method="update", 
        args=list(list(visible=c(TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE)),
                  list(title="events",
                       annotations=list(c(),c(),c(),c(),c(),c(),c(),c(),c(),c())))
      )
    )
  )
)

#make the plot
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
  layout(hovermode='compare', 
         xaxis=list(title="Date"),
         yaxis=list(title="Approval Rating (%)"),
         updatemenus=updatemenus)

htmlwidgets::saveWidget(as.widget(p), "approval.html")
