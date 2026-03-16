####################################################################
############ Standard Setup ########################################
FROM zlskidmore/bio-base:1.0.0

ARG DEBIAN_FRONTEND=noninteractive

# set the environment variables
ENV PRESEQ_VERSION="3.2.0"


####################################################################
############## PRESEQ Install ######################################

WORKDIR /tmp/build

# install ISA-L (required for static linking)
RUN set -eux; \
    wget https://github.com/smithlabcode/preseq/releases/download/v${PRESEQ_VERSION}/preseq-${PRESEQ_VERSION}.tar.gz; \
    tar -xzf preseq-${PRESEQ_VERSION}.tar.gz; \
    mkdir -p preseq-${PRESEQ_VERSION}/build; \
    cd preseq-${PRESEQ_VERSION}/build; \
    ../configure --enable-hts; \
    make CXXFLAGS='-include cstdint'; \
    make install; \
    rm -rf /tmp

WORKDIR /data
