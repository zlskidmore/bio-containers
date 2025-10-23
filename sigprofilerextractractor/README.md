# Overview
Docker image instructions for SigProfilerExtractor, used to extract mutation signatures

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/sigprofilerextractor:1.2.4 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/sigprofilerextractor:latest --push .
```

# Run
```
docker run -it zlskidmore/sigprofilerextractor:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/sigprofilerextractor
