
e <-globalenv()

if (e.prod) setwd('C:\\Users\\bvh8924\\Scripts\\')
wd <- getwd()

e$scriptDir <- paste(wd, "\\", sep = "")

e$dirName <- e$scriptDir
e$prodDir <- e$scriptDir
e$analyticsLog <- 'C:\\Users\\bvh8924\\eclipse-workspace\\apache-tomcat-9.0.24\\logs\\analytics.log'


#set working dir
e$workDir <- 'C:\\Users\\bvh8924\\Documents\\'
e$tradestationOutDir <- "C:\\Users\\bvh8924\\OneDrive\\Apps\\tradestation\\"
e$onedriveDir <- "C:\\Users\\bvh8924\\OneDrive\\Apps\\"
e$workingDir <- e$workDir
myenv <- e
myList <- list()
myenv$myList <- myList

#set working dir
myenv$workDir <- 'C:\\Users\\bvh8924\\OneDrive\\apps\\tradestation'
myenv$processFile <- ""
myenv$processDir <- 'C:\\Users\\bvh8924\\OneDrive\\apps'
myenv$trigDir <- 'C:\\Users\\bvh8924\\OneDrive\\Documents'
myenv$trigFile <- 'TriggerOut.txt'
myenv$trigFile <- "C:\\Users\\bvh8924\\OneDrive\\Documents\\TriggerOut.txt"
print(myenv)

