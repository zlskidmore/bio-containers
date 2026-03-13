####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV R_VERSION=4.5.3

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    gfortran \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libgit2-dev \
    libicu-dev \
    libjpeg-dev \
    libpcre2-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtiff-dev \
    libxml2-dev \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

###################################################################
########### stand up R ############################################

# change working dir
WORKDIR /tmp

# install R
RUN set -eux; \
    wget https://cran.r-project.org/src/base/R-4/R-${R_VERSION}.tar.gz; \
    tar -xzf R-${R_VERSION}.tar.gz; \
    cd R-${R_VERSION}; \
    ./configure --prefix=/usr/local --with-x=no --enable-R-shlib; \
    make -j$(nproc); \
    make install; \
    cd /; \
    rm -rf /tmp/R-${R_VERSION}*

# install R packages
RUN R --vanilla -e 'options(Ncpus = parallel::detectCores()); install.packages(c( \
  "arrow", \
  "BiocManager", \
  "curl", \
  "data.table", \
  "devtools", \
  "fs", \
  "ggforce", \
  "here", \
  "httr", \
  "janitor", \
  "jsonlite", \
  "matrixStats", \
  "openssl", \
  "patchwork", \
  "Rcpp", \
  "readxl", \
  "remotes", \
  "tidyverse", \
  "xml2", \
  "yaml" \
), repos="https://cloud.r-project.org")'

RUN R --vanilla -e 'options(Ncpus = parallel::detectCores()); BiocManager::install(c( \
  "BiocGenerics", \
  "Biostrings", \
  "GenomicAlignments", \
  "GenomicRanges", \
  "IRanges", \
  "Rsamtools", \
  "rtracklayer", \
  "S4Vectors", \
  "SummarizedExperiment" \
), ask = FALSE, update = FALSE)'
