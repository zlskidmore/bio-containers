####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV FASTQC_VERSION="0.13.0" \
    PATH="/opt/fastqc:${PATH}"

# Official release archive checksum for the version above
ARG FASTQC_SHA256=c9504d47752e79ecfe61691e09bf367fc3f15167ac3fe83d9e33534fffbcc301

# Python 3 is provided by bio-base; Java and fonts support headless reports.
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-dejavu-core \
    libfontconfig1 \
    libharfbuzz0b \
    openjdk-17-jre-headless \
    unzip \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## FASTQC Install ######################################

WORKDIR /tmp/build

RUN set -eux; \
    curl -fsSL "https://github.com/s-andrews/FastQC/releases/download/v${FASTQC_VERSION}/fastqc_v${FASTQC_VERSION}.zip" -o fastqc.zip; \
    echo "${FASTQC_SHA256}  fastqc.zip" | sha256sum -c -; \
    unzip -q fastqc.zip; \
    mv FastQC /opt/fastqc; \
    chmod 0755 /opt/fastqc/fastqc; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN test "$(fastqc --version)" = "FastQC v${FASTQC_VERSION}" && \
    fastqc --help > /dev/null && java -version

WORKDIR /data

