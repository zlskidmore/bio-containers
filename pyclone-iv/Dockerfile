####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV PYCLONE_VERSION="0.2.0"
ENV PHYCLONE_VERSION="0.8.0"
ENV NUMBA_CACHE_DIR="/tmp/numba_cache"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    libhdf5-dev \
    libopenblas-dev \
    liblapack-dev \
    gfortran \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## pyclone-vi Install ##################################

WORKDIR /opt

# pyclone-vi
RUN set -eux; \
    wget https://github.com/Roth-Lab/pyclone-vi/archive/refs/tags/${PYCLONE_VERSION}.tar.gz; \
    tar -xzvf ${PYCLONE_VERSION}.tar.gz; \
    cd pyclone-vi-${PYCLONE_VERSION}; \
    python -m venv venv; \
    ./venv/bin/pip install --upgrade pip setuptools wheel; \
    ./venv/bin/pip install -e . --no-cache-dir

ENV PATH="/opt/pyclone-vi-${PYCLONE_VERSION}/venv/bin:${PATH}"

# phyclone
RUN set -eux; \
    wget https://github.com/Roth-Lab/PhyClone/archive/refs/tags/${PHYCLONE_VERSION}.tar.gz; \
      tar -xzvf ${PHYCLONE_VERSION}.tar.gz; \
      cd PhyClone-${PHYCLONE_VERSION}; \
      python -m venv venv; \
      ./venv/bin/pip install --upgrade pip setuptools wheel; \
      ./venv/bin/pip install -e . --no-cache-dir

ENV PATH="/opt/PhyClone-${PHYCLONE_VERSION}/venv/bin:${PATH}"

WORKDIR /data


