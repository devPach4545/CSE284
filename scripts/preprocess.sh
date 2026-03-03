#!/bin/bash

# Paths
INPUT=~/public/ps2/ibd/ps2_ibd.lwk
OUTDIR=~/ibd_project/data
STEM=$OUTDIR/lwk_chr22

echo "Step 1: Subset to chr22 + basic QC filters"
plink \
    --bfile $INPUT \
    --chr 22 \
    --geno 0.05 \
    --mind 0.1 \
    --maf 0.01 \
    --hwe 1e-6 \
    --make-bed \
    --out ${STEM}_qc

echo "Step 2: LD pruning - generate prune list"
plink \
    --bfile ${STEM}_qc \
    --indep-pairwise 50 5 0.2 \
    --out ${STEM}_prune

echo "Step 3: Apply prune list"
plink \
    --bfile ${STEM}_qc \
    --extract ${STEM}_prune.prune.in \
    --make-bed \
    --out ${STEM}_pruned
echo "Done. Final files: ${STEM}_pruned.bed/bim/fam"