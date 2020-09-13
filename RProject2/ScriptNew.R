library('xts')
myenv <-get("myenv")

directory <- myenv$workDir
#fname = "ESH19 March5 5min.txt"
fname  <-myenv$processFile

ds <- read.csv(file = fname, header = TRUE)
ds$DateTime <- paste(ds$Date, ds$Time, sep = ' ')
mdata <- as.matrix(ds[, c('Open', 'High', 'Low', 'Close')])



rowIndex <- as.POSIXlt(ds$DateTime, tz = "", format = "%m/%d/%Y %H:%M")
ts1 <- xts(mdata, order.by = rowIndex)
dataPeriod <- as.character(periodicity(ts1))
dataPeriod1 <- as.vector(periodicity(ts1))
print(dataPeriod1)

if (dataPeriod <= 5) {
    ts5 <- to.minutes5(ts1)
    ts10 <- to.minutes10(ts1)
    ts15 <- to.minutes15(ts1)

    tts10 <- to.period(ts1, 'minutes', 10)
    print(start(tts10))


    

}

#Write 15min file
xts15 <- as.xts(ts15)
dts15 <- as.data.frame(xts15)
colnames(dts15) <- c('Open', 'High', 'Low', 'Close')
#Write 10min file
xts10 <- as.xts(ts10)
dts10 <- as.data.frame(ts10)
colnames(dts10) <- c('Open', 'High', 'Low', 'Close')
#Write 5min file
xts5 <- as.xts(ts5)
dts5 <- as.data.frame(ts5)
colnames(dts5) <- c('Open', 'High', 'Low', 'Close')

##add elements to dataframe.
myenv = get("myenv")
myenv$myList = list(dts15, dts10, dts5)


myenv$mylist <- myList
