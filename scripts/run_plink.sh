#!/bin/bash

INPUT=~/ibd_project/data/lwk_chr22_pruned
OUTDIR=~/ibd_project/data

echo "Running PLINK IBD estimation..."

plink \
    --bfile $INPUT \
    --genome \
    --min 0.05 \
    --out $OUTDIR/lwk_plink_ibd

echo "Done. Output: $OUTDIR/lwk_plink_ibd.genome"