# work from latest LTS ubuntu release
FROM ubuntu:24.04

# set variables
ENV r_version=4.5.1

# run update
RUN apt-get update -y && apt-get install -y \
  gfortran \
  libreadline-dev \
  libpcre3-dev \
  libcurl4-openssl-dev \
  build-essential \
  zlib1g-dev \
  libbz2-dev \
  liblzma-dev \
  openjdk-8-jdk \
  wget \
  libssl-dev \
  libxml2-dev \
  libnss-sss \
  libpcre2-dev \
  libfreetype6-dev \
  libfontconfig1-dev \
  git \
  vim \
  less

# change working dir
WORKDIR /usr/local/bin

# install R
RUN wget https://cran.r-project.org/src/base/R-4/R-${r_version}.tar.gz
RUN tar -zxvf R-${r_version}.tar.gz
WORKDIR /usr/local/bin/R-${r_version}
RUN ./configure --prefix=/usr/local/ --with-x=no
RUN make
RUN make install

# install R packages
RUN R --vanilla -e 'install.packages(c("devtools", "BiocManager"), repos="http://cran.us.r-project.org")'
RUN R --vanilla -e 'BiocManager::install(c("DNAcopy", "biomaRt", "copynumber", "GenVisR", "fgsea", "deseq2", "EBSeq", "BSgenome.Hsapiens.UCSC.hg19", "BSgenome.Hsapiens.UCSC.hg38", "TxDb.Hsapiens.UCSC.hg19.knownGene", "TxDb.Hsapiens.UCSC.hg38.knownGene", "org.Hs.eg.db", "NanoStringDiff", "ATACseqQC", "BSgenome.Mmusculus.UCSC.mm10", "TxDb.Mmusculus.UCSC.mm10", "BiocGenerics"))'
RUN R --vanilla -e 'install.packages(c("optparse", "mdscore", "ggplot2", "data.table", "sequenza", "dplyr", "reshape2", "tidyr", "viridis", "cowplot", "ggalluvial", "msigdbr", "ggdendro", "gridExtra", "deconstructSigs", "tidyverse", "splitstackshape", "fastcluster", "gtools", "kableExtra", "mutSignatures", "R.utils"), repos = "http://cran.us.r-project.org")'

# copy any one-off R scripts over
RUN mkdir -p /opt/scripts/R
COPY scripts/optitype2imgt.R /opt/scripts/R
