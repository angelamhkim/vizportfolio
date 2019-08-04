#load libraries
library(foreign)
library(plotly)

#2016 elections
#read the data, downloaded DTA from the American National Election Studies Data Center
dat <- read.dta("anes_timeseries_2016_Stata12.dta")
#get a subset of the data for the variables we're interested in:
#V161006: Who did you vote for in 2012?
#V161027: Who did you vote for president?
dat <- dat[,which(names(dat)%in%c("V161006","V161027"))]

#make an answer key 
previous2012 <- as.vector(unique(dat$V161006))
today2016 <- as.vector(unique(dat$V161027))
answers <- cbind(previous2012, today2016) %>% as.data.frame()

#from Obama in 2012 to
#Trump in 2016
OtoT <- length(which(as.vector(dat$V161006)==answers$previous2012[2] & 
        as.vector(dat$V161027)==answers$today2016[2]))
#Hilary in 2016
OtoH <- length(which(as.vector(dat$V161006)==answers$previous2012[2] & 
               as.vector(dat$V161027)==answers$today2016[4]))
#refused to answer or did not vote for president in 2016
OtoR <- length(which(as.vector(dat$V161006)==answers$previous2012[2] & 
                       as.vector(dat$V161027)%in%answers$today2016[c(1,3)]))
#other candidate
OtoO <- length(which(as.vector(dat$V161006)==answers$previous2012[2] & 
                       as.vector(dat$V161027)%in%answers$today2016[c(5,6,7)]))

#from Romney in 2012 to
#Trump in 2016
RtoT <- length(which(as.vector(dat$V161006)==answers$previous2012[3] & 
                       as.vector(dat$V161027)==answers$today2016[2]))
#Hilary in 2016
RtoH <- length(which(as.vector(dat$V161006)==answers$previous2012[3] & 
                       as.vector(dat$V161027)==answers$today2016[4]))
#refused to answer or did not vote for president in 2016
RtoR <- length(which(as.vector(dat$V161006)==answers$previous2012[3] & 
                       as.vector(dat$V161027)%in%answers$today2016[c(1,3)]))
#other candidate
RtoO <- length(which(as.vector(dat$V161006)==answers$previous2012[3] & 
                       as.vector(dat$V161027)%in%answers$today2016[c(5,6,7)]))

#2012 elections
#read and subset the data
dat12 <- read.dta("anes_timeseries_2012_Stata12.dta")
dat12 <- dat12[,which(names(dat12)%in%c("interest_whovote2008","postvote_presvtwho"))]

#make an answer key 
previous2008 <- as.vector(unique(dat12$interest_whovote2008))
today2012 <- as.vector(unique(dat12$postvote_presvtwho))
answers <- cbind(previous2008, today2012) %>% as.data.frame()

#from Obama in 2008 to
#Obama in 2012
OtoOb <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[1] & 
                       as.vector(dat12$postvote_presvtwho)==answers$today2012[2]))
#Romney in 2012
OtoRo <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[1] & 
                        as.vector(dat12$postvote_presvtwho)==answers$today2012[4]))
#other candidate in 2012
OtoO <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[1] & 
                        as.vector(dat12$postvote_presvtwho)==answers$today2012[5]))
#NA
OtoNA <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[1] & 
                        as.vector(dat12$postvote_presvtwho)%in%answers$today2012[c(1,3,6,7)]))

#from McCain in 2008 to 
#Obama in 2012
MtoOb <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[4] & 
                        as.vector(dat12$postvote_presvtwho)==answers$today2012[2]))
#Romney in 2012
MtoRo <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[4] & 
                        as.vector(dat12$postvote_presvtwho)==answers$today2012[4]))
#other candidate in 2012
MtoO <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[4] & 
                       as.vector(dat12$postvote_presvtwho)==answers$today2012[5]))
#NA
MtoNA <- length(which(as.vector(dat12$interest_whovote2008)==answers$previous2008[4] & 
                        as.vector(dat12$postvote_presvtwho)%in%answers$today2012[c(1,3,6,7)]))

#make sankey chart
p <- plot_ly(
  type = "sankey",
  orientation = "h",
  
  node = list(
    label = c("2012 Obama", "2012 Romney", "Hilary", "Trump", "2016 Other", 
              "2016 No Answer", "2008 Obama", "McCain", "2012 Other", "2012 No Answer"),
    color = c("blue","red","blue","red","grey","grey","blue","red","grey","grey"),
    pad = 15,
    thickness = 20,
    line = list(
      color = "black",
      width = 0.5
    )
  ),
  
  link = list(
    source = c(0,0,0,0,1,1,1,1,6,6,6,6,7,7,7,7),
    target = c(2,3,4,5,2,3,4,5,0,1,8,9,0,1,8,9),
    value =  c(62,7,3,1656,2,50,2,1214,1882,173,30,619,89,1200,31,382)
  )
) %>% 
  layout(
    title = "Basic Sankey Diagram",
    font = list(
      size = 10
    )
  )

htmlwidgets::saveWidget(as_widget(p), "sankey.html")
