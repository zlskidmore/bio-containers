# AGFusion 1.5.0

Annotate and visualize gene fusions, including predicted cDNA, CDS and protein sequences, reading-frame effects, exon structures and protein domains. This image follows the bio-containers Dockerfile style and uses `zlskidmore/bio-base:1.0.0`, a Python virtual environment and headless Matplotlib. No entrypoint is set; explicitly supply `agfusion` after the image name.

## Build

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t zlskidmore/agfusion:1.5.0 -t zlskidmore/agfusion:latest --load .
```

Multi-platform loading requires the containerd image store. For one local architecture, use `docker build -t zlskidmore/agfusion:1.5.0 .`. Replace `--load` with `--push` when ready to publish.

## Reference setup

References are kept outside the image. Mount the same reference directory during installation and analysis. `PYENSEMBL_CACHE_DIR=/data/pyensembl` keeps the PyEnsembl cache in that mounted directory.

For human GRCh38, explicitly pair Ensembl release 115 with the AGFusion 115 database:

```bash
mkdir -p references results

docker run --rm -v "$PWD/references:/data" zlskidmore/agfusion:1.5.0 \
  pyensembl install --species homo_sapiens --release 115

docker run --rm -v "$PWD/references:/data" zlskidmore/agfusion:1.5.0 \
  agfusion download --species homo_sapiens --release 115 --dir /data
```

The AGFusion 115 database URL was verified available. Functional sequence tests used GRCh37 release 75, which has upstream expected sequences; release 115 was not functionally benchmarked. For GRCh37, use release 75 in both commands. Breakpoint coordinates must match the reference assembly used to call the fusions. Keep the downloaded database's original `agfusion.SPECIES.RELEASE.db` filename: AGFusion infers the reference release from it. Reference installation needs network access and disk space for annotation, transcript/protein FASTA files and indexes. The image does not automatically download references at startup.

## Run with STAR-Fusion output

```bash
docker run --rm \
  -v "$PWD/references:/data" \
  -v "$PWD/star-fusion.fusion_predictions.tsv:/inputs/fusions.tsv:ro" \
  -v "$PWD/results:/results" \
  zlskidmore/agfusion:1.5.0 \
  agfusion batch -a starfusion -f /inputs/fusions.tsv \
  -db /data/agfusion.homo_sapiens.115.db -o /results/agfusion
```

The STAR-Fusion parser accepts `#FusionName` or `#fusion_name`, the left/right gene and breakpoint columns, and versioned Ensembl gene IDs. AGFusion annotates fusion predictions; run your fusion caller first. Default annotation uses canonical isoforms; add `--noncanonical` to consider other isoform combinations.

```bash
docker run --rm zlskidmore/agfusion:1.5.0 agfusion annotate --help
docker run --rm zlskidmore/agfusion:1.5.0 agfusion batch --help
docker run --rm zlskidmore/agfusion:1.5.0 agfusion download -a
```
## Links

- [AGFusion release](https://github.com/murphycj/AGFusion/releases/tag/v1.5.0)
- [bio-containers AGFusion directory](https://github.com/zlskidmore/bio-containers/tree/main/agfusion) (available after you add this directory)
- [Zachary Skidmore](https://zlskidmore.github.io)

Use `dockerhub-overview.md` for the Docker Hub overview. Local builds are not published automatically.

