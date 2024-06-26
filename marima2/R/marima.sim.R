##' 
##' @title marima.sim
##' 
##' @description  Simulation of multivariate arma model of
##' type 'marima'.
##'
##' @param kvar   dimension of one observation (from
##' kvar-variate time series).
##' @param ar.model   array holding the autoregressive part of model, 
##' organised as in the marima$ar.estimates. May be
##' empty (default = NULL) when there is no autoregressive part.
##' @param ar.dif     array holding differencing polynomium of model, 
##' typically generated by applying the function define.dif. May be
##' empty (default = NULL) when differencing is not included.
##' @param ma.model   array holding the moving average part of model, 
##' organised as in the marima$ma.estimates. May be
##' empty (default = NULL) when there is no moving average part.
##' @param averages   vector holding the kvar averages of the
##' variables in the simulated series.
##' @param resid.cov   (kvar x kvar) innovation covariance matrix.
##' @param nstart   number of extra observations in the start of the
##' simulated series to be left out before returning. If nstart=0
##' in calling marima.sim a suitable value is computed (see code).
##' @param seed   seed for random number generator (set.seed(seed)).
##' If the seed is set by the user, the random number generator is 
##' initialised. If seed is not set no initialisation is done.
##' @param nsim   length of (final) simulated series.
##'
##' @return Simulated kvar variate time series of length = nsim.
##' 
##' @examples
##' 
##' library(marima)
##' data(austr)
##' old.data <- t(austr)[, 1:83]
##' Model2   <- define.model(kvar=7, ar=c(1), ma=c(1),
##'                     rem.var=c(1, 6, 7), indep=NULL)
##' Marima2  <- marima(old.data, means=1, ar.pattern=Model2$ar.pattern, 
##'  ma.pattern=Model2$ma.pattern, Check=FALSE, Plot="none", penalty=4)
##' 
##' resid.cov  <- Marima2$resid.cov
##' averages   <- Marima2$averages
##'         ar <- Marima2$ar.estimates
##'         ma <- Marima2$ma.estimates
##' 
##' N    <- 1000
##' kvar <- 7
##' 
##' y.sim <- marima.sim(kvar = kvar, ar.model = ar, ma.model = ma, 
##'   seed = 4711, averages = averages, resid.cov = resid.cov, nsim = N)
##'
##' # Now simulate from model identified by marima (model=Marima2).
##' # The relevant ar and ma patterns are saved in 
##' # Marima2$out.ar.pattern and Marima2$out.ma.pattern, respectively: 
##' 
##' Marima.sim <- marima( t(y.sim), means=1, 
##'      ar.pattern=Marima2$out.ar.pattern, 
##'      ma.pattern=Marima2$out.ma.pattern, 
##'      Check=FALSE, Plot="none", penalty=0) 
##'
##' cat("Comparison of simulation model and estimates", 
##' " from simulated data. \n")
##'    round(Marima2$ar.estimates[, , 2], 4)
##' round(Marima.sim$ar.estimates[, , 2], 4)
##' 
##'    round(Marima2$ma.estimates[, , 2], 4)
##' round(Marima.sim$ma.estimates[, , 2], 4)
##'
##' @importFrom stats rnorm
##'
##' @export 

marima.sim <- function(kvar = 1, ar.model = NULL, ar.dif = NULL,
                       ma.model = NULL, 
                       averages=rep(0 , kvar), resid.cov = diag(kvar), 
                       seed = NULL, nstart = 0, nsim = 0 )
{

# ar.model<-ma.model<-ar.dif<-NULL;nsim<-1000;averages<-rep(0, kvar)
#    cat("ar dimensions ", dim(ar.model), "\n")
#    cat("ma dimensions ", dim(ma.model), "\n")

  if(is.null(ar.model)) {ar.model <- array(c(diag(kvar)), 
                                           dim=c(kvar, kvar, 1))
                      }
    Lar <- dim(ar.model)[3]
#    cat("Lar = ", Lar, "\n")
    
   if(is.null(ma.model)) {ma.model <- array(c(diag(kvar)), 
                                           dim=c(kvar, kvar, 1))
                         }
Lam <- dim(ma.model)[3]
#  cat("Lam = ", Lam, "\n")
   if(is.null(ar.dif)){ar.dif <- array(c(diag(kvar)), 
                                           dim=c(kvar, kvar, 1))
                      }
Ldif <- dim(ar.dif)[3]
#   cat("Ldif = ", Ldif, "\n")
    
ar.model.d <- pol.mul(ar.model, ar.dif, L=(Lar+Ldif-2+1))

    if(is.null(ma.model)){ma.model <- array(c(diag(kvar)), 
                                           dim=c(kvar, kvar, 1))
                     }
Lam <- dim(ma.model)[3]
    if(is.null(ar.dif)){ar.dif <- array(c(diag(kvar)), 
                                           dim=c(kvar, kvar, 1))
Ldif <- dim(ar.dif)[3]                    }
ar.model.d <- pol.mul(ar.model, ar.dif, L=(Lar+Ldif-2+1))

LL <- pol.order(ar.model.d) + 1
ar.model.d <- ar.model.d[ , , 1:LL ]
#   cat("LL = ", LL, "\n")

if( nstart==0 ) { nstart = 10 * (LL+Lam) }
# cat("nstart = ", nstart, "\n")
if( nsim == 0 ) { cat("Length of simulated series <= 0 \n") }

# requireNamespace("MASS")

ntot  <- nstart + nsim
if( !is.null(seed) ) { set.seed(seed) }

u <- matrix(rnorm(ntot * kvar), ncol = kvar)
Sigma <- matrix(resid.cov, ncol = kvar)
 e    <- eigen(Sigma)
 V    <- e$vectors
 B    <- matrix( V %*% diag(sqrt(e$values)) %*% t(V) , nrow = kvar )

u <- u %*% B

# cat("ntot = ", ntot, " \n")
# resid.cov = residual covariance matrix
# averages  = averages of y's
# cat("Simulate ", nsim, " innovations \n")
#, set.seed(seed)
#, su <- mvrnorm(n = (nsim+nstart), mu = averages*0, 
#        Sigma = resid.cov, tol = 1e-6, 
#        empirical = FALSE, EISPACK = FALSE)
#    cat("Covariance matrix ", resid.cov, " \n")
#    print(resid.cov)
    u <- t(u)
#    print(u)
    y <- u
#    print(y)
 nbeg <- LL + Lam + 1
# cat("nbeg =", nbeg, " \n")
for (i in nbeg:ntot){
    if ( LL > 1 ) { for (j in 2: LL) {
        ti <- i + 1 - j
#        cat("ti = ", ti, " \n")
    y[, i] <- y[, i] - matrix(ar.model.d[, , j], nrow = kvar)%*%y[, ti ]
    }
              }
    if (Lam >1) { for (j in 2: Lam) {
        ti <- i + 1 -j
    y[, i] <- y[ , i ] + matrix(ma.model[, , j]  , nrow = kvar)%*%u[, ti ]
     }
              }
}

  for ( i in 1:kvar ){
    y[, i] <- y[, i] + averages[i]
  }
  y <- t(y[, (1+nstart):(nsim+nstart)])
  return(y)
}


            













