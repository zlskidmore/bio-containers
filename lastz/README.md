# Overview
Docker image instructions for lastz, pairwise aligner

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/lastz:latest --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/lastz:1.04.52 --push .
```

# Run
```
docker run -it zlskidmore/lastz:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/lastz
