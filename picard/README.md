# Overview
Docker image instructions for picard, general bam/sam/cram utilities

# Build
```bash
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/picard:3.4.0 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t zlskidmore/picard:latest --push .
```

# Run
```
docker run -it zlskidmore/picard:latest /bin/bash
java -jar $PICARD
```

# Dockerhub
https://hub.docker.com/r/zlskidmore/picard
