library(icesTAF)

url <- "https://stockassessment.org/datadisk/stockassessment/userdirs/user3/nscod16-ass02/"

#######################
## 1  Download files ##
#######################

mkdir("data")
files <- readLines(paste0(url, "data/"))
files <- grep("\\.dat", files, value=TRUE)
files <- gsub(".*>(.*.dat)<.*", "\\1", files)
for(i in seq_along(files))
  download.file(paste0(url,"data/",files)[i], paste0("data/",files)[i], quiet=TRUE)

mkdir("run")
download.file(paste0(url,"run/model.cfg"), "run/model.cfg", quiet=TRUE)
download.file(paste0(url,"run/sam.pin"), "run/sam.pin", quiet=TRUE)
download.file(paste0(url,"run/sam"), "run/sam", quiet=TRUE)
Sys.chmod("run/sam")

mkdir("src")
files <- readLines(paste0(url, "src/"))
files <- grep("\\.R", files, value=TRUE)
files <- gsub(".*>(.*.R)<.*", "\\1", files)
for(i in seq_along(files))
  download.file(paste0(url,"src/",files)[i], paste0("src/",files)[i], quiet=TRUE)

##################
## 2  Run model ##
##################

## Comment out readLines function
code <- readLines("src/datavalidator.R")
beg <- grep("readLines<-function", code)
end <- match("}", dv[-(1:beg)]) + beg
code[beg:end] <- paste("##", code[beg:end])
writeLines(code, "src/datavalidator.R")

## Write sam.dat
source("src/datascript.R")

## Run model
setwd("run")
system("./sam -nr 2 -noinit")
