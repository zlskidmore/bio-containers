####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

ARG somalier_version=0.3.1
ARG nim_version=v1.6.10
ARG hts_nim_ref=0.2.8
ARG slivar_ref=0.3.1

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgomp1 \
    libopenblas-dev \
    libpcre3-dev \
    libssl-dev \
    libtool \
    xz-utils \
 && rm -rf /var/lib/apt/lists/*

#####################################################################
############# Somalier #############################################

WORKDIR /tmp/build

# Build/install Nim
RUN set -eux && \
    git clone -b "${nim_version}" --depth 1 https://github.com/nim-lang/nim "nim-${nim_version}" && \
    cd "nim-${nim_version}" && \
    /bin/bash build_all.sh && \
    ln -sf "/tmp/build/nim-${nim_version}/bin/nim" /usr/local/bin/nim && \
    ln -sf "/tmp/build/nim-${nim_version}/bin/nimble" /usr/local/bin/nimble

# hts-nim
RUN set -eux && \
    export HOME=/tmp && \
    curl -fsSL "https://github.com/brentp/hts-nim/archive/refs/tags/v${hts_nim_ref}.tar.gz" -o hts-nim.tar.gz && \
    tar -xzf hts-nim.tar.gz && \
    mv hts-nim-* hts-nim && \
    cd hts-nim && \
    nimble install -y

# slivar + arm64 -mpopcnt fix
RUN set -eux && \
    export HOME=/tmp && \
    curl -fsSL "https://github.com/brentp/slivar/archive/refs/tags/v${slivar_ref}.tar.gz" -o slivar.tar.gz && \
    tar -xzf slivar.tar.gz && \
    mv slivar-* slivar && \
    if [ "$(uname -m)" = "aarch64" ]; then \
      find slivar -type f \( -name "*.nim" -o -name "*.cfg" -o -name "*.nimble" \) -exec sed -i '/-mpopcnt/d' {} \; || true; \
    fi && \
    cd slivar && \
    nimble install -y

# somalier + arm64 fixes
RUN set -eux && \
    export HOME=/tmp && \
    curl -fsSL "https://github.com/brentp/somalier/archive/refs/tags/v${somalier_version}.tar.gz" -o somalier.tar.gz && \
    tar -xzf somalier.tar.gz && \
    mv "somalier-${somalier_version}" somalier && \
    if [ "$(uname -m)" = "aarch64" ]; then \
      find somalier -type f \( -name "*.nim" -o -name "*.cfg" -o -name "*.nimble" \) -exec sed -i '/-mpopcnt/d' {} \; || true; \
      sed -i '/slivar/d' somalier/somalier.nimble || true; \
    fi && \
    cd somalier && \
    nimble install -d -y && \
    nim c -d:danger -d:nsb_static -d:release -d:nimDebugDlOpen -d:openmp \
      -d:blas=openblas -d:lapack=openblas \
      -o:/usr/local/bin/somalier src/somalier && \
    somalier --help >/dev/null

######################################################
########## Helper files ###############################
WORKDIR /opt/somalier
RUN set -eux && \
    wget -q "https://github.com/brentp/somalier/files/9954286/sites.chm13v2.T2T.vcf.gz" && \
    wget -q "https://github.com/brentp/somalier/files/3412453/sites.hg19.vcf.gz" && \
    wget -q "https://github.com/brentp/somalier/files/3412454/sites.hg38.nochr.vcf.gz" && \
    wget -q "https://github.com/brentp/somalier/files/3412455/sites.GRCh37.vcf.gz" && \
    wget -q "https://github.com/brentp/somalier/files/3412456/sites.hg38.vcf.gz" && \
    wget -q "https://github.com/brentp/somalier/files/4566475/sites.hg38.rna.vcf.gz"

#######################################################
################# Cleanup #############################

# Clean build artifacts + nimble cache
RUN rm -rf /tmp/build /tmp/.nimble /tmp/.cache /root/.cache || true
