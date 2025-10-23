# Overview
Docker image instructions for samtools, general bam file utilities

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/samtools:1.21 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/samtools:latest --push .
```

# Run
```
docker run -it zlskidmore/samtools:latest /bin/bash
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/samtools
