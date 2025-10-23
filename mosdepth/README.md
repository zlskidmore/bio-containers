# Overview
Docker image instructions for mosdepth, used to calculate coverage

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/mosdepth:0.3.11 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/mosdepth:latest --push .
```

# Run
```
docker run -it zlskidmore/mosdepth:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/mosdepth
