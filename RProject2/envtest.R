


myenv <- new.env()
dirname <- dirname(sys.frame(1)$ofile)
myenv$dirName <- dirname
myenv$scriptDir <-dirname
myList <- list()
myenv$mylist =myList

#set working dir
myenv$workDir <- 'C:\\Users\\bvh8924\\OneDrive\\apps\\tradestation'
myenv$processFile <-""
myenv$processDir <- 'C:\\Users\\bvh8924\\OneDrive\\apps'
myenv$trigDir <- 'C:\\Users\\bvh8924\\OneDrive\\Documents'
myenv$trigFile <-   'TriggerOut.txt'
myenv$trigFile <- "C:\\Users\\bvh8924\\OneDrive\\Documents\\TriggerOut.txt"
print(myenv)
