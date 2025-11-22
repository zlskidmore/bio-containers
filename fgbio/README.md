# Overview
Docker image instructions for fgbio, general ngs tools with support for UMI

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/fgbio:3.0.0 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/fgbio:latest --push .
```

# Run
```
docker run -it zlskidmore/fgbio:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/fgbio
