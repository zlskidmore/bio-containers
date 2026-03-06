####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV PICARD_VERSION=3.4.0 \
    PICARD_DIR=/usr/local/share/picard \
    PICARD_JAR=/usr/local/share/picard/picard.jar

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre \
    r-base \
    r-base-dev \
    && rm -rf /var/lib/apt/lists/*

####################################################################
########### setup picard ###########################################
RUN set -eux; \
    mkdir -p "${PICARD_DIR}"; \
    curl -fsSL -o "${PICARD_JAR}" \
        "https://github.com/broadinstitute/picard/releases/download/${PICARD_VERSION}/picard.jar"; \
    chmod 0644 "${PICARD_JAR}"; \
    printf '#!/bin/sh\nexec java -jar /usr/local/share/picard/picard.jar "$@"\n' > /usr/local/bin/picard; \
    chmod 0755 /usr/local/bin/picard

WORKDIR /data
