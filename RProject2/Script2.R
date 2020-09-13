library('quantmod')
library('dplyr')

#OneDrive path 
myenv <- get('myenv')
directory = myenv$workDir
fname = myenv$processFile
#fname = paste(directory, fname, sep = '')

if (!exists("foo", mode = "function")) source(paste(myenv$scriptDir, 'myFUN.R', sep = '\\'), echo = FALSE)



###GEt all teh dataframes 

myList <- myenv$myList
ndfs <- length(myList)

for (i in 1:ndfs) {
    df <- as.data.frame(myList[i])
    
    m1 <- getOHLC(df)

    
    mfinal <- data.frame()
    dt <- data.frame(df$DateTime)
    dfDIs <-getDIs(m1)
    keyDn <- getkeyReversalDn(m1)
    keyUp <- getkeyReversalUp(m1)
    pivots <- getAllPivots(m1)
    #vols <- getVols(m1)
    vols <- getVols(m1)
    TRs <- getTR(m1)
    NuTRs <- getTR1(m1)
    

    

    m1 <- m1[, c('Open', 'High', 'Low', 'Close')]
    m1 <- cbind(dt, m1)
    

    mfinal <- cbind(m1, dfDIs, keyDn, keyUp)
    
    
    text1 = paste("outkey", i, ".txt", sep = '')
    write.csv(mfinal, paste(directory, text1, sep = '\\'), row.names = FALSE)
    mfinal <- cbind(m1, pivots)
    text1 = paste("outpivots", i, ".txt", sep = '')
    write.csv(mfinal, paste(directory, text1, sep = '\\'), row.names = FALSE)
    mfinal <- cbind(m1, NuTRs, vols)
    #mfinal <- cbind(m1, TRs, vols)
    text1 = paste("outvols", i, ".txt", sep = '')
    write.csv(mfinal, paste(directory, text1, sep = '\\'), row.names = FALSE)
}
#Sys.getenv()
