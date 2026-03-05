#!/bin/bash

# Get project root (one level up from scripts/)
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

INPUT="$PROJECT_DIR/outputs/data/lwk_chr22_pruned"
OUTDIR="$PROJECT_DIR/outputs/data"

echo "Running PLINK IBD estimation..."

plink \
    --bfile $INPUT \
    --genome \
    --min 0.05 \
    --out $OUTDIR/lwk_plink_ibd

echo "Done. Output: $OUTDIR/lwk_plink_ibd.genome"