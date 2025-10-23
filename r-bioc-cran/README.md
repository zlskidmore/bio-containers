# Overview
Docker image instructions for R, and relevant data-munging/bioinformatic libraris

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/r-bioc-cran:4.5.1 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/r-bioc-cran:latest --push .
```

# Run
```
docker run -it zlskidmore/r-bioc-cran:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/r-bioc-cran
