#dan sucks

require(rvest)
require(XML)

#SELECT STARTDATE
#earliest startdate ("1958-08-16")
startdate <- as.Date("1958-08-16")
enddate <- Sys.Date()

#DECLARE FINAL LIST
hot100total <- data.frame(date=character(),
                     artist=character(),
                     title=character(),
                     currpos=integer(),
                     prevpos=integer(),
                     stringsAsFactors=FALSE)

#LOOP WEEKLY FROM START DATE TO CURRENT WEEK
while(startdate <= enddate){
  
  #PARSE DATE    
  day <- format(startdate,format="%d")
  month <- format(startdate,format="%m")
  year <- format(startdate,format="%Y")
  
  #UPDATE URL
  page <- paste("http://www.billboard.com/charts/hot-100/",year,"-",month,"-",day,sep="")
  
  #GET PAGE HTML
  pagehtml <- html(page)
  
  #DECLARE INDIVIDUAL WEEK'S LIST
  hot100ind <- data.frame(date=character(100),
                          artist=character(100),
                          title=character(100),
                          currpos=integer(100),
                          prevpos=integer(100),
                          stringsAsFactors=FALSE)

  #ITERATE THROUGH TOP 100
  for(i in 1:100){
      hot100ind$date[i] <- as.character(startdate)
      hot100ind$currpos[i] <- as.integer(xpathSApply(pagehtml,"//div[@class = 'row-primary']//span[@class = 'this-week']",xmlValue)[i])
      hot100ind$prevpos[i] <- as.integer(xpathSApply(pagehtml,"//div[@class = 'row-secondary']//div[@class = 'stats-last-week']//span[@class = 'value']",xmlValue)[i])
      hot100ind$title[i] <- gsub('\t|\n','',xpathSApply(pagehtml,"//div[@class = 'row-primary']//div[@class = 'row-title']//h2",xmlValue)[i])
      hot100ind$artist[i] <- gsub('\t|\n','',xpathSApply(pagehtml,"//div[@class = 'row-primary']//div[@class = 'row-title']//h3",xmlValue)[i])
      }
  
  #APPEND INDIVIDUAL WEEK'S LIST TO FINAL LIST
  hot100total <- rbind(hot100total,hot100ind)
  
  #CHANGE DATE VAR TO FOLLOWING WEEK
  startdate = startdate+7
  
  print(startdate)
}
