################################################################################
########### load in libraries and data #########################################

# pass command line args
args <- commandArgs(trailingOnly=TRUE)

# hla predictions from optitype
optitypeHLA <- read.delim(args[1])

# imgt mapping between hla annotations and imgt ids
alleleList <- read.csv(args[2], comment.char = "#")

################################################################################
############ convert HLA predictions to standard format ########################

# grab just the HLA predictions
keep <- c("A1", "A2", "B1", "B2", "C1", "C2")
optitypeHLA <- as.character(t(optitypeHLA[,keep]))

# make them consistent with IMGT allele list
#optitypeHLA <- paste0("HLA-", optitypeHLA)

################################################################################
############ Grab the imgt HLA identifier for these ############################

optitype2imgt <- function(x, y){
  # find the imgt entries which corresond to the input
  y <- y[grepl(x, y$Allele, fixed=TRUE),"AlleleID"]
  y <- as.character(y[1])
  return(y)
}

result <- unlist(lapply(optitypeHLA, optitype2imgt, alleleList))

# make sure its unique
result <- unique(result)

################################################################################
########### format and return the results ######################################

# collapse and return
result <- paste0(result, collapse=",")
write(result, "")


