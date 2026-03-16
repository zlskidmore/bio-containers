####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV MULTIQC_VERSION="1.33" \
    PATH="/opt/venv/bin:$PATH"

####################################################################
############## MULTIQC Install #####################################

WORKDIR /app

# set venv
RUN python -m venv /opt/venv && \
    pip install --no-cache-dir --upgrade pip setuptools wheel

# install
RUN set -eux; \
    wget https://github.com/MultiQC/MultiQC/archive/refs/tags/v${MULTIQC_VERSION}.tar.gz; \
    tar -xzf v${MULTIQC_VERSION}.tar.gz; \
    cd MultiQC-${MULTIQC_VERSION}; \
    pip install --no-cache-dir .; \
    cd /app; \
    rm -rf "MultiQC-${MULTIQC_VERSION}" multiqc.tar.gz

WORKDIR /data
