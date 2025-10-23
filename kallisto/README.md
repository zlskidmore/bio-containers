# Overview
Docker image instructions for samtools, general bam file utilities

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/kallisto:0.51.1 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/kallisto:latest --push .
```

# Run
```
docker run -it zlskidmore/kallisto:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/kallisto
