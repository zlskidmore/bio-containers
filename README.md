# bio-containers
A unified repository for Dockerfiles and container build recipes used in bioinformatics workflows. This collection spans commonly used genomics tools (e.g., samtools, optitype, etc.) and custom environments tailored for reproducibility, portability, and deployment across HPC and cloud platforms.

Each tool has its own subdirectory with:
- Dockerfile
- Optional wrapper script necessary for building

## Why This Repo?
Managing individual repositories for each tool became unnecessarily fragmented. This centralized structure:
- Reduces duplication
- Makes maintenance easier
- Simplifies CI/CD integration
- Supports batch updates and dependency tracking

## Usage
You can build any container individually, here is an example workflow:
```bash
cd samtools
docker build -t zlskidmore/samtools:latest .
```

## Licensing & Notes
Each tool retains its original license. This repository only provides containerization logic.
