library('quantmod')
library('dplyr')

#OneDrive path 


getOHLC <- function(df) {
    m1 <- as.matrix(df[, c('Open', 'High', 'Low', 'Close')])
    return(m1)
}

getPivots <- function(m2, y) {


    m <- m2[2:4]
    #avg1<-(m[1]+ m[2]+ m[3])/3
    avg1 <- signif(mean(m),6)
    if (y == 1) retval <- avg1
    if (y == 2) retval <- 2 * avg1 - m[1]
    if (y == 3) retval <- avg1 - (m[1] - m[2])
    if (y == 4) retval <- 2 * avg1 - m[2]
    if (y == 5) retval <- avg1 + (m[1] - m[2])

    return(signif(retval, 6))

}

#getAllPivots function 
getAllPivots <- function(mOHLC) {
    m1 = mOHLC
    pSx <- apply(m1, 1, mean)
    signif(pSx, 5)
    mfinal <- matrix(pSx,, 1)
    #pS1
    pS1 <- apply(m1, 1, function(x) getPivots(x, 2))

    mpS1 <- matrix(pS1,, 1)
    mfinal <- cbind(mfinal, mpS1)
    #pS2
    pS2 <- apply(m1, 1, function(x) getPivots(x, 3))
    mpS2 <- matrix(pS2,, 1)
    mfinal <- cbind(mfinal, mpS2)
    #pR1
    pR1 <- apply(m1, 1, function(x) getPivots(x, 4))
    mpR1 <- matrix(pR1,, 1)
    mfinal <- cbind(mfinal, mpR1)
    #pR2
    pR2 <- apply(m1, 1, function(x) getPivots(x, 5))
    mpR2 <- matrix(pR2,, 1)
    mfinal <- cbind(mfinal, mpR2)
    colnames(mfinal) <- c('pSx', 'pS1', 'pS2', 'pR1', 'pR2')
    #Finally attach teh mfinal to m1
    #    mfinal <- cbind(m1, mfina
    return(mfinal)

}

#shift function syntax 
shift <- function(d, k) rbind(tail(d, k), head(d, - k), deparse.level = 0)
getPreviousClose <- function(mOHLC) {
    PrevClose <- as.vector(mOHLC[, c('Close')])
    length(PrevClose)
    shifted <- shift(PrevClose, 1)
    shifted = as.matrix(shifted[2,])
    shifted = rbind(c(0), shifted)
    nrow(shifted)
    ncol(shifted)
    colnames(shifted) <- c('PrevClose')
    return(shifted)
}

#KeyreersalDn function
getkeyReversalDn <- function(mat1) {
    mat1 <- as.matrix(mat1)
    mat1 <- mat1[, 2:4]
    mlen <- nrow(mat1)

    vKeyDn <- vector()

    for (i in mlen:2) {
        if (mat1[i, 1] > mat1[i - 1, 1]) {
            if (mat1[i, 3] < mat1[i - 1, 3]) {
                vKeyDn[i] = mat1[i, 1]
            } else vKeyDn[i] = 0.0
            } else vKeyDn[i] = 0.0

    }
    vKeyDn[1] = 0.0
    return(vKeyDn)

}


#keyreversalup

#KeyUp reversal function
getkeyReversalUp <- function(mat1) {
    mat1 <- as.matrix(mat1)
    mat1 <- mat1[, 2:4]
    mlen <- nrow(mat1)
    vKeyUp <- vector()


    for (i in mlen:2) {
        if (mat1[i, 2] < mat1[i - 1, 2]) {
            if (mat1[i, 3] > mat1[i - 1, 3]) {
                vKeyUp[i] = mat1[i, 2]
            } else vKeyUp[i] = 0.0
            } else vKeyUp[i] = 0.0

    }
    vKeyUp[1] = 0.0
    return(vKeyUp)

}

#True Renge 
getTR <- function(m) {

    m <- as.matrix(m)
    mlen = nrow(m)
    TR <- vector("list", mlen)

    for (i in mlen:2) {
        print(mlen)
        h <- m[i, 2]
        l <- m[i, 3]
        c <- m[i, 4]
        pc <- m[i - 1, 4]


        if (pc > h) h <- pc
        if (pc < l) l <- pc
        TR[[i]] <- h - l
    }

    return(TR)
}


#getVols function for SD and vols 
getVols <- function(x) {
    m <- as.matrix(x)

    temp <- c(0, diff(log(m[, c('Close')])))
    
    df <- as.data.frame(cbind( temp))
    df <- mutate(df, PCHG = temp * 100)
    df$AvgRet <- rollapply(df$PCHG, 20, mean, fill = NA, align = 'right',na.rm = TRUE)

    df$SD20 <- runSD(n = 20, df$PCHG)
    
    
    
    

    

    df <- mutate(df, ProbRet = pnorm(PCHG, mean = AvgRet, sd = SD20, lower.tail = TRUE) * 100)
    
    
    mret <- df[, c('PCHG', 'AvgRet', 'SD20', 'ProbRet')]
    mret <-signif(mret,5)
    return(as.matrix(mret))

}

#getVols1 using dplyr package 
getVols1 <- function(x) {
    m <- as.matrix(x)

    temp <- c(0, diff(log(m[, c('Close')])))

    df <- as.data.frame(cbind(temp))
    df <- mutate(df, PCHG = temp * 100)
    
    samp30 <- dplyr::sample_n(df, 30)
    mn <- round(mean(as.numeric(samp30$PCHG)), 4)
    stdev <- round(sd(as.numeric(samp30$PCHG)), 4)
    df$AvgRet <- mn
    df$SD20 <- stdev

    print("Before TRPROb")

    df <- dplyr::mutate(df, ProbRet1 = pnorm(as.numeric(PCHG), mean = mn, sd = stdev), ProbRet = round(ProbRet1 * 100, 3))



    mret <- df[, c('PCHG', 'AvgRet', 'SD20', 'ProbRet')]
    #mret <- signif(mret, 5)
    return(as.matrix(mret))

}



#getDIS unction

getDIs <- function(x) {

    ts2 <- as.data.frame(x)
    diffs <- as.data.frame(cbind('DIp' = diff(ts2[, c('High')]), 'DIn' = diff(ts2[, c('Low')])))
    diffs <- rbind(c(0, 0), diffs)
ts2 <-cbind(ts2,diffs)
    ts2 <- mutate(ts2, DIp = ifelse(DIp > 0, DIp, 0), DIn = ifelse(DIn < 0, DIn, 0))
    ts2 <- mutate(ts2, DIp  = round(DIp, 2),DIn =round(DIn, 2) )
    return(ts2[, c('DIp', 'DIn')])
    }

#getTR1 function using dplyr
getTR1 <- function(m) {
    ds <- as.data.frame(m)

    
    
    
    ds <- dplyr::mutate(ds, LClose = lag(Close, n =1L))
    ds <- dplyr::mutate(ds, TRHigh = ifelse(High - LClose > 0, High, LClose))
    ds <- dplyr::mutate(ds, TRLow = ifelse(Low - LClose < 0, Low, LClose))
    ds <- dplyr::mutate(ds, NuTR = round(TRHigh - TRLow, 3))
    samp30 <- dplyr::sample_n(ds, 20)
    #samp30 <-ds
    #mn <- mean(as.numeric(samp30$NuTR))
    mn <- round(mean(as.numeric(samp30$NuTR), na.rm =TRUE), 4)
    #stdev <- sd(as.numeric(samp30$NuTR))
    stdev <- round(sd(as.numeric(samp30$NuTR), na.rm = TRUE), 4)
    


print("Before TRPROb")
    dfFilter <- dplyr::mutate(ds, TRProb1 = pnorm(as.numeric(NuTR), mean = mn, sd = stdev), TRProb = round(TRProb1 * 100, 3))
    #dfFilter <- dplyr::mutate(dfFilter, TRMean =mn , TRSD= round(stdev, 3))
    ds1 <- dfFilter
        return(ds1[, c('NuTR', 'TRProb')])

}
#getTRs with mean and sd 
getTRSeed <- function(m,mn, stdev) {
    ds <- as.data.frame(m)




    ds <- dplyr::mutate(ds, LClose = lag(Close, n = 1L))
    ds <- dplyr::mutate(ds, TRHigh = ifelse(High - LClose > 0, High, LClose))
    ds <- dplyr::mutate(ds, TRLow = ifelse(Low - LClose < 0, Low, LClose))
    ds <- dplyr::mutate(ds, NuTR = round(TRHigh - TRLow, 3))
    
    
    
    lmn <- mn
    
    lstdev <- stdev



    print("Before TRPROb")
    dfFilter <- dplyr::mutate(ds, TRProb1 = pnorm(as.numeric(NuTR), mean = lmn, sd = lstdev), TRProb = round(TRProb1 * 100, 3))
    dfFilter <- dplyr::mutate(dfFilter, TRMean = lmn, TRSD = lstdev)
    ds1 <- dfFilter
    return(ds1[, c('NuTR', 'TRProb')])

}

#getVolswith sseed values for madn and sdhjyu
#getVols function for SD and vols 
getVolsSeed <- function(x) {
    m <- as.matrix(x)

    temp <- c(0, diff(log(m[, c('Close')])))

    df <- as.data.frame(cbind(temp))
    df <- mutate(df, PCHG = temp * 100)
    df$AvgRet <- rollapply(df$PCHG, 20, mean, fill = NA, align = 'right', na.rm = TRUE)

    df$SD20 <- runSD(n = 20, df$PCHG)
    samp30 <- dplyr::sample_n(df, 20)
    mn <- mean(as.numeric(samp30$PCHG), na.rm = TRUE)
    stdev <- sd(as.numeric(samp30$PCHG), na.rm = TRUE)
    df$AvgRet <- mn

    df$SD20 <- stdev

    #df <- mutate(df, ProbRet = pnorm(PCHG, mean = AvgRet, sd = SD20, lower.tail = TRUE) * 100)
    df <- mutate(df, ProbRet = pnorm(PCHG, mean = mn, sd = stdev, lower.tail = TRUE) * 100)

    mret <- df[, c('PCHG', 'AvgRet', 'SD20', 'ProbRet')]
    mret <- signif(mret, 5)
    return(as.matrix(mret))

}



#getVols with maen and sd values in inuts. 
#getVols function for SD and vols 
getVolSeed <- function(x,mn, stdev) {
    m <- as.matrix(x)

    temp <- c(0, diff(log(m[, c('Close')])))

    df <- as.data.frame(cbind(temp))
    
    df <- mutate(df, PCHG = temp * 100)
    df$AvgRet <- as.numeric(mn)

    df$SD20 <- as.numeric(stdev)

    df <- mutate(df, ProbRet1 = pnorm(PCHG, mean =AvgRet , sd = SD20), ProbRet = round(ProbRet1, 4) * 100)


    mret <- df[, c('PCHG','AvgRet','SD20', 'ProbRet')]
    
    return(as.matrix(mret))

}