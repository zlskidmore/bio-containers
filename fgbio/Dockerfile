####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV FGBIO_VERSION="3.1.1"
ENV FGBIO="/usr/local/bin/fgbio.jar"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############### get FGBIO ##########################################

WORKDIR /usr/local/bin

# grab the jar file
RUN set -eux && \
    wget -q -O "${FGBIO}" \
        "https://github.com/fulcrumgenomics/fgbio/releases/download/${FGBIO_VERSION}/fgbio-${FGBIO_VERSION}.jar"; \
    chmod 0644 "${FGBIO}"; \
    printf '#!/bin/sh\nexec java -jar /usr/local/bin/fgbio.jar "$@"\n' > /usr/local/bin/fgbio; \
    chmod 0755 /usr/local/bin/fgbio

