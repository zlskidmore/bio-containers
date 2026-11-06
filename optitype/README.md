# OptiType 1.5.0

OptiType types HLA class I loci HLA-A, HLA-B and HLA-C from DNA or RNA reads. This image follows the existing bio-containers Dockerfile style and uses `zlskidmore/bio-base:1.0.0`. It includes native RazerS3, GLPK (the default solver), CBC, and the reference data shipped with upstream v1.5.0. It does not type HLA class II.

## Build

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t zlskidmore/optitype:1.5.0 -t zlskidmore/optitype:latest \
  --load .
```

Multi-platform loading requires a containerd image store. For a single local architecture, use `docker build -t zlskidmore/optitype:1.5.0 .` instead. Publishing requires replacing `--load` with `--push` when you are ready.

## Run

```bash
docker run --rm zlskidmore/optitype:1.5.0 optitype --version
docker run --rm zlskidmore/optitype:1.5.0 optitype check-deps

# Paired-end DNA; output is written beneath the mounted directory.
docker run --rm -v "$PWD:/data" zlskidmore/optitype:1.5.0 \
  optitype run --dna -i /data/reads_1.fastq -i /data/reads_2.fastq \
  --threads 4 -p sample -o /data/optitype-results

# Paired-end RNA with CBC instead of the default GLPK solver.
docker run --rm -v "$PWD:/data" zlskidmore/optitype:1.5.0 \
  optitype run --rna -i /data/reads_1.fastq -i /data/reads_2.fastq \
  --solver cbc --threads 4 -p sample -o /data/optitype-rna-results
```

There is no tool entrypoint: explicitly supply `optitype run` after the image name. In version 1.5, this replaces `OptiTypePipeline.py`; paired input uses a separate `-i` before each file. Outputs include `sample_result.tsv` and `sample_coverage_plot.pdf`. Commercial CPLEX is not included. The bundled reference is the release's reference, not an automatic download of the newest IMGT/HLA database.

## Links

- [Upstream release](https://github.com/FRED-2/OptiType/releases/tag/v1.5.0)
- [bio-containers OptiType directory](https://github.com/zlskidmore/bio-containers/tree/main/optitype) (available after adding this directory to the repository)
- [Zachary Skidmore](https://zlskidmore.github.io)

Use `dockerhub-overview.md` for the Docker Hub repository overview.

