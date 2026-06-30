####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV SIGPROFILEREXTRACTOR_VERSION=1.4.0
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# run update and install necessary tools ubuntu tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    libjpeg8-dev

#####################################################################
########### sigProfilerExtractor ####################################

WORKDIR /tmp/build

RUN set -eux; \
    wget https://github.com/AlexandrovLab/SigProfilerExtractor/archive/refs/tags/v${SIGPROFILEREXTRACTOR_VERSION}.tar.gz; \
    tar -xzf v${SIGPROFILEREXTRACTOR_VERSION}.tar.gz; \
    cd SigProfilerExtractor-${SIGPROFILEREXTRACTOR_VERSION}; \
    pip install --no-cache-dir .; \
    mkdir -p /usr/local/lib/python3.12/dist-packages/sigProfilerPlotting/templates; \
    chmod -R a+rwx /usr/local/lib/python3.12/dist-packages/sigProfilerPlotting; \
    cd /; \
    rm -rf /tmp/build/SigProfilerExtractor-${SIGPROFILEREXTRACTOR_VERSION}*

RUN set -eux; \
    python3 -c "from SigProfilerMatrixGenerator import install as genInstall; genInstall.install('GRCh38'); genInstall.install('GRCh37')"; \
    mkdir -p /data/; \
    cd /data; \
    wget -q ftp://alexandrovlab-ftp.ucsd.edu/pub/tools/SigProfilerExtractor/Example_data/21BRCA.zip; \
    unzip -q 21BRCA.zip; \
    rm -f 21BRCA.zip

# below fix is just to fix old driver issue on intended cluster, not needed if cluster drivers are updated
RUN set -eux; \
    pip uninstall -y torch torchvision torchaudio || true && \
    pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cu124

WORKDIR /data

