# Overview
Docker image instructions for bedtools, general bed file manipulations

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/bedtools:2.31.1 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/bedtools:latest --push .
```

# Run
```
docker run -it zlskidmore/bedtools:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/bedtools
