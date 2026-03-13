####################################################################
############ Standard Setup ########################################
FROM zlskidmore/r-bioc-cran:4.5.3

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV SCICLONE_VERSION=1.1.1 \
    NORMT3_VERSION=1.0.4

###################################################################
########### sciclone   ############################################

# change working dir
WORKDIR /tmp

# install NORMT3 dep
RUN set -eux; \
    wget https://cran.r-project.org/src/contrib/Archive/NORMT3/NORMT3_${NORMT3_VERSION}.tar.gz; \
    R CMD INSTALL --use-C17 NORMT3_1.0.4.tar.gz; \
    rm -rf /tmp/NORMT3_${NORMT3_VERSION}.tar.gz

# install bioc dep
RUN R --vanilla -e 'options(Ncpus = parallel::detectCores()); BiocManager::install(c("limma"), ask = FALSE, update = FALSE)'

# install cran dep
RUN R --vanilla -e 'options(Ncpus = parallel::detectCores()); install.packages(c( \
  "MKmisc", \
  "plotrix", \
  "rgl", \
  "TeachingDemos" \
), repos="https://cloud.r-project.org")'

# install bmm dep
RUN R --vanilla -e 'options(Ncpus = parallel::detectCores()); devtools::install_github("genome/bmm")'

# install sciclone
RUN set -eux; \
     wget https://github.com/genome/sciclone/archive/refs/tags/${SCICLONE_VERSION}.tar.gz; \
     R CMD INSTALL ${SCICLONE_VERSION}.tar.gz; \
     rm -rf /tmp/${SCICLONE_VERSION}.tar.gz

WORKDIR /data
