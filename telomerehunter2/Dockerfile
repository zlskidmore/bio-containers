####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV TELOMEREHUNTER2_VERSION="1.0.9"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    fonts-liberation \
    libasound2t64 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    chromium \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## telhunter Install ###################################

WORKDIR /opt

RUN set -eux; \
    git clone https://github.com/ferdinand-popp/telomerehunter2.git; \
    cd telomerehunter2; \
    python -m venv venv; \
    ./venv/bin/pip install --upgrade pip; \
    ./venv/bin/pip install -e . --no-cache-dir

ENV PATH="/opt/telomerehunter2/venv/bin:${PATH}"

WORKDIR /data
