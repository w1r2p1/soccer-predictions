computeLayerOdm <- function(A, strNorm, b, c, odmIter) {
  teamStr <- exp(strNorm)
  a <- teamStr[, 1];
  d <- teamStr[, 2];
  A <- b * A + c;
  i <- 1

  while (i <= odmIter) {
    strPost <- computeAD(A, a, d, odmIter);
    aPost <- strPost[, 1]
    dPost <- strPost[, 2]
    aDel <- matrix(aPost - a)
    dDel <- matrix(dPost - d)
    a <- aPost
    d <- dPost
    i <- i + 1
  }
  
  strPostNorm <- log(strPost)
  strPostNorm
}

computeAD <- function(A, a, d, odmIter) {
  strRelA = scaleRating(A, a, odmIter);
  aRelA <- strRelA[["x"]]
  dRelA <- strRelA[["y"]]
  strRelD <- scaleRating(t(A), d, odmIter);
  dRelD <- strRelD[["x"]]
  aRelD <- strRelD[["y"]]
  aPost <- (aRelA + aRelD) / 2;
  dPost <- (dRelA + dRelD) / 2;
  strPost <- matrix(c(aPost, dPost), 2, 2)
  strPost
}

scaleRating <- function(A, x, odmIter) {
  y <- A %*% (1 / x);
  i <- 1
 
  while (i <= odmIter) {
    xPost <- t(A) %*% (1 / y);
    yPost <- A %*% (1 / x);
    x <- xPost;
    y <- yPost;
    i <- i + 1
  }
  
  v <- list(x=x, y=y)
  v
}