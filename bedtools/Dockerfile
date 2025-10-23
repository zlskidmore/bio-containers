# work from latest LTS ubuntu release
FROM ubuntu:24.04

# set environment variables
ENV bedtools_version="2.31.1"

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    build-essential \
    libnss-sss \
    vim \
    wget \
    curl \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev

# install bedtools
WORKDIR /usr/local/bin
RUN curl -SL https://github.com/arq5x/bedtools2/archive/v${bedtools_version}.tar.gz \
    > v${bedtools_version}.tar.gz
RUN tar -xzvf v${bedtools_version}.tar.gz
WORKDIR /usr/local/bin/bedtools2-${bedtools_version}
RUN make
RUN ln -s /usr/local/bin/bedtools2-${bedtools_version}/bin/bedtools /usr/local/bin/bedtools

# set default command
CMD ["bedtools"]
