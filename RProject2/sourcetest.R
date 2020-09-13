    rm(list = ls()) #REmove teh memory and envvs() suppsoedly.


e <- globalenv()
myenv <- e

e.prod <- 0
if (e.prod) setwd('C:\\Users\\bvh8924\\Scripts\\')
wd <- getwd()



scriptDir <- paste(wd, "\\", sep = "")
e$scriptDir <-scriptDir

#dirName <- dirname(sys.frame(1)$ofile)
e$dirName <- e$scriptDir
dirName <- e$scriptDir


print(dirName)

source(paste(dirName, 'envall.R', sep = '\\'), echo = FALSE)

#Do get teh trigger file
df1 <- read.csv(myenv$trigFile)
processFile <- df1[1, 1]

myenv$processFile <- paste(myenv$processDir, processFile, sep = '\\')
print(myenv$processFile)

#Callscript1.R
print(scriptDir)
source(paste(scriptDir, 'Script1.R', sep = '\\'), echo = FALSE)
source(paste(scriptDir, 'Script2.R', sep = '\\'), echo = TRUE)
