INPUT=~/public/ps2/ibd/ps2_ibd.lwk
OUTDIR=~/ibd_project/data
STEM=$OUTDIR/lwk_chr22

# so we onnly run this on chromosome 22, we can save time and space by subsetting the data first
plink \
    --bfile $INPUT \
    --chr 22 \
    --geno 0.05 \
    --mind 0.1 \
    --maf 0.01 \
    --hwe 1e-6 \
    --make-bed \
    --out ${STEM}_qc

# we ld prune here to get a set of independent SNPs 
plink \
    --bfile ${STEM}_qc \
    --indep-pairwise 50 5 0.2 \
    --out ${STEM}_prune

# now subset the data to only the pruned set
plink \
    --bfile ${STEM}_qc \
    --extract ${STEM}_prune.prune.in \
    --make-bed \
    --out ${STEM}_pruned