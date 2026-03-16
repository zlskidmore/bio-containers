####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV FASTP_VERSION="1.2.0" \
    ISA_VERSION="2.32.0"

# Additional libs needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    cmake \
    help2man \
    libdeflate-dev \
    libtool \
    nasm \
    && rm -rf /var/lib/apt/lists/*

####################################################################
############## FASTP Install ######################################

WORKDIR /tmp/build

# install ISA-L (required for static linking)
RUN set -eux; \
    wget https://github.com/intel/isa-l/archive/refs/tags/v${ISA_VERSION}.tar.gz; \
    tar -xzf v${ISA_VERSION}.tar.gz; \
    cd isa-l-${ISA_VERSION}; \
    ./autogen.sh; \
    ./configure; \
    make; \
    make install; \
    rm -rf /tmp/build/isa-l

# install highway
RUN set -eux; \
    git clone --depth=1 --branch 1.3.0 https://github.com/google/highway.git; \
    cd highway; \
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DHWY_ENABLE_TESTS=OFF -DHWY_ENABLE_EXAMPLES=OFF; \
    cmake --build build; \
    cmake --install build; \
    rm -rf /tmp/build/highway

# get source (you can also use browser to download from master or releases)
RUN set -eux ;\
    wget https://github.com/OpenGene/fastp/archive/refs/tags/v${FASTP_VERSION}.tar.gz; \
    tar -xzf v${FASTP_VERSION}.tar.gz; \
    cd fastp-${FASTP_VERSION}; \
    make -j; \
    make install; \
    rm -rf /tmp

# build
#cd fastp
#make -j

# Install
#sudo make install


WORKDIR /data
