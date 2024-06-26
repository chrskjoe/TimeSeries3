## #----------------------------------------------------------------
## # These packages must be installed
## install.packages("Rcpp")
## install.packages("R6")
## install.packages("splines")
## install.packages("digest")
## # cpp matrix library
## install.packages("RcppArmadillo")
## # For develop install
## install.packages("devtools", type="source")
## install.packages("roxygen2")
## # For testing and building vignettes
## install.packages("rmarkdown")
## install.packages("R.rsp")
## install.packages("data.table")
## install.packages("plotly")
## install.packages("pbs")
## install.packages("V8")

#----------------------------------------------------------------
# Go
library(devtools)
library(roxygen2)

# Load the package directly
 ## document()
 ## pack <- as.package("../marimamod1")
 ## load_all(pack)


# ----------------------------------------------------------------
# Misc
#
# Add new vignette
# Don't use name of existing file, it will overwrite! usethis::use_vignette("model-selection")


# ----------------------------------------------------------------
# Running tests in folder "tests/testthat/"
#
# https://kbroman.org/pkg_primer/pages/tests.html
# http://r-pkgs.had.co.nz/tests.html
#
# Initialize first time the the testing framework
# use_testthat()
# Init new test
#use_test("newtest")



# # Run all tests
document()
#test()

# # Run the examples
#load_all(as.package("../marima2/"))
#run_examples()

# # Run tests in a single file
# test_file("tests/testthat/test-rls-heat-load.R")

# ----------------------------------------------------------------
# The version (move the value from DESCRIPTION to other places, so only update it in DESCRIPTION)
txt <- scan("DESCRIPTION", character())
(ver <- txt[which(txt == "Version:") + 1])
# Not needed to write elsewhere now

# ----------------------------------------------------------------
# Build the package
document()
# Run the "vignettes/make.R" to build a cache
build(".", vignettes=TRUE)

# The file
gzfile <- paste0("../marima2_",ver,".tar.gz")

# Install it
install.packages(gzfile, repos=NULL)
library(marima2)
hertil

# Put it online (go and commit)
file.copy(gzfile, "~/g/course-site-02417/material/", overwrite=TRUE)
file.remove(gzfile)
oi
# ----------------------------------------------------------------


# ----------------------------------------------------------------
# Build binary package
#system(paste0("R CMD INSTALL --build ",gzfile))
# ----------------------------------------------------------------



# ----------------------------------------------------------------
# Test before release

# Online, receive email (builds again, so when ok, then build the package file again above before submit!)
devtools::check_win_devel()

# Check the build locally
devtools::check_built(gzfile)

# Does give different results than check() above
#system(paste0("R CMD check --as-cran ",gzfile))
system(paste0("R CMD check --as-cran ",gzfile))
unlink("marimamod1.Rcheck/", recursive=TRUE)

# Use for more checking:
# https://docs.r-hub.io/



#-----------------
# Use Rcpp and RcppArmadillo (2022-05): Some problem (segmentation fault) occured, something (Rostream...) was added to the 'src/RcppExports.cpp' file, however in some weird way it disappeared again!
#
# Update if new functions are added to the src folder
#Rcpp::compileAttributes()

# New package from scratch, see what is generated and correct that in the current package
#library(RcppArmadillo)
#RcppArmadillo.package.skeleton("marimamod1", path = "~/tmp/")

# on WINDOWS:
# Install rtools
# Run in R:
#writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
# Restart R and check if rtools are found:
#Sys.which("make")


#-----------------
# Run another version of R (a linux in podman)
# see https://hub.docker.com/u/rocker

# Open terminal and "sudo su" (needed for podman to access files)
# Run "podman run --rm -d -p 8787:8787 -e ROOT=TRUE -e PASSWORD=pw -v $(pwd):/home/rstudio rocker/rstudio"
# In browser go to "localhost:8787"
# login: rstudio and pw
# Open make.R 
# Set working directory to this files directory
# Run installation of packages
# Make a cup of coffee
# Go to terminal and run:
#    "sudo apt-get install xml2 qpdf texlive"

# Other versions with
# "podman run --rm -p 8787:8787 -e PASSWORD=pw -v /home/pbac/g:/home/rstudio/g rocker/rstudio:3.6.1"







# ----------------------------------------------------------------
# OLD, not exporting everything anymore
#
# Update NAMESPACE, use this function to export all functions! (with @export, but S3methods (e.g. print.lm) will not get exported, so change it to export)
## docit <- function(){
##     document()
##     # Read
##     nm <- "NAMESPACE"
##     x <- scan(nm, what="character", sep="\n",blank.lines.skip=FALSE)
##     # Manipulate x
##     for(i in 1:length(x)){
##         if(length(grep("^S3method", x[i])) > 0){
##             x[i] <- gsub(",",".",gsub("S3method", "export", x[i]))
##         }
##      }
##     #
##     write(x, nm)
## }
## docit()

