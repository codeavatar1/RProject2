library('zoo')
library('xts')
directory = 'C:\\Users\\bvh8924\\OneDrive\\apps\\tradestation\\'
fname = "ESH19 March11 1minnew.txt"
fname = paste(directory, fname, sep = '')
ds <- read.csv(file = fname, header = TRUE)


xds <- xts(ds, order.by = as.POSIXlt(ds$DateTime, tz = "", format = "%m/%d/%Y %H:%M"))

#xds <- xts(ds, order.by = as.Date(ds$DateTime, format = "%m/%d/%y %H:%M"))
indexClass(xds)
indexTZ(xds)
periodicity(xds)

start(xds)
end(xds)
str(xds)


write.csv(xds, file = 'datetime.txt')
indexClass(xds)
##


#nhours(xds)
#to.period(xds, k = 1,indexAt = "startof", period = 'minutes')
#to.period(x = xds, k = 2)
nhours(xds)
#to.minutes10(xds)
str(xds)

##
mdat <- as.matrix(ds[, c(2:5)])
rowIndex <- as.POSIXlt(ds$DateTime, tz = "", format = "%m/%d/%Y %H:%M")
ts1 <- xts(mdat, order.by = rowIndex)
periodicity(ts1)
nhours(ts1)
to.minutes5(ts1)


