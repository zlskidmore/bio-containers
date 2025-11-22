# work from latest LTS ubuntu release
FROM ubuntu:24.04

# set the environment variables
ENV fgbio_version="3.0.0"
ENV FGBIO="/usr/local/bin/fgbio.jar"

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    vim \
    less \
    curl \
    libnss-sss \
    openjdk-8-jdk \
    unzip \
    wget

# grab tthe jarr file
WORKDIR /usr/local/bin
RUN wget https://github.com/fulcrumgenomics/fgbio/releases/download/${fgbio_version}/fgbio-${fgbio_version}.jar
RUN chmod 0644 /usr/local/bin/fgbio-${fgbio_version}.jar
RUN ln -s /usr/local/bin/fgbio-${fgbio_version}.jar /usr/local/bin/fgbio.jar

# set default command to print help
CMD ["java", "-jar", "/usr/local/bin/fgbio.jar"]
