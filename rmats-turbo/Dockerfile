####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV RMATS_VERSION="4.4.0" \
    STAR_VERSION="2.7.11b" \
    PATH="/opt/venv/bin:${PATH}"

# Source archive checksums for the versions above
ARG RMATS_SHA256=a47f8667ad0b49d50580b9a70003b52d69da408adaf35662447b549cd301e9d9
ARG STAR_SHA256=3f65305e4112bd154c7e22b333dcdaafc681f4a895048fa30fa7ae56cac408e7

# Additional libs needed (build tools, Python, zlib, and samtools are in bio-base)
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    gfortran \
    libblas-dev \
    libgsl-dev \
    liblapack-dev \
    python3-dev \
    xxd \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## rMATS-turbo Install ##################################

# set venv (Ubuntu 24.04 manages the system Python environment)
RUN python -m venv /opt/venv && \
    pip install --no-cache-dir "Cython==3.1.8" "setuptools==78.1.1"

WORKDIR /tmp/build

# Build the standard statistical model without optional PAIRADISE/DARTS.
RUN set -eux; \
    curl -fsSL "https://github.com/Xinglab/rmats-turbo/archive/refs/tags/v${RMATS_VERSION}.tar.gz" -o rmats.tar.gz; \
    echo "${RMATS_SHA256}  rmats.tar.gz" | sha256sum -c -; \
    tar -xzf rmats.tar.gz; \
    cd "rmats-turbo-${RMATS_VERSION}"; \
    # Skip the upstream setup script that sources ~/.bashrc for conda.
    : > setup_environment.sh; \
    # SSE2 is an x86 compiler option; the rMATS C sources use no SSE intrinsics.
    case "$(dpkg --print-architecture)" in \
        amd64) ;; \
        arm64) sed -i 's/ -msse2//g' rMATS_C/Makefile ;; \
        *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    ./build_rmats --no-paired-model --no-darts-model; \
    mkdir -p /opt/rmats/rMATS_C /opt/rmats/rMATS_P /opt/rmats/rMATS_R; \
    install -m 0755 rmats.py /opt/rmats/rmats.py; \
    cp cp_with_prefix.py ./*.so /opt/rmats/; \
    install -m 0755 rMATS_C/rMATSexe /opt/rmats/rMATS_C/rMATSexe; \
    cp rMATS_P/*.py /opt/rmats/rMATS_P/; \
    cp rMATS_R/*.R /opt/rmats/rMATS_R/; \
    cp LICENSE /opt/rmats/; \
    ln -s /opt/rmats/rmats.py /usr/local/bin/rmats.py; \
    ln -s /opt/rmats/rmats.py /usr/local/bin/rmats; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############## STAR Install ########################################

# STAR is needed when rMATS starts from FASTQ files.
WORKDIR /tmp/build

RUN set -eux; \
    curl -fsSL "https://github.com/alexdobin/STAR/archive/refs/tags/${STAR_VERSION}.tar.gz" -o star.tar.gz; \
    echo "${STAR_SHA256}  star.tar.gz" | sha256sum -c -; \
    tar -xzf star.tar.gz; \
    cd "STAR-${STAR_VERSION}/source"; \
    # STAR includes SIMDe for ARM; remove x86-only flags on that architecture.
    case "$(dpkg --print-architecture)" in \
        amd64) simd_flags="-msse2" ;; \
        arm64) simd_flags="" ;; \
        *) echo "Unsupported architecture" >&2; exit 1 ;; \
    esac; \
    make -j"$(nproc)" STAR CXXFLAGS_SIMD="${simd_flags}"; \
    install -m 0755 STAR /usr/local/bin/STAR; \
    mkdir -p /opt/STAR; \
    cp ../LICENSE /opt/STAR/; \
    cd /; \
    rm -rf /tmp/build

####################################################################
############ Check Essentials ######################################
RUN rmats.py --version && rmats.py --help && STAR --version && samtools --version

WORKDIR /data

