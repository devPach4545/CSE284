INPUT=~/ibd_project/data/lwk_chr22_pruned
OUTDIR=~/ibd_project/data


echo "Running PLINK IBD estimation..."


plink \
    --bfile $INPUT \
    --genome \
    --min 0.05 \
    --out $OUTDIR/lwk_plink_ibd


echo "PLINK complete."
echo "Output: $OUTDIR/lwk_plink_ibd.genome"


echo ""
echo "Quick summary:"
echo "Total pairs flagged (PI_HAT >= 0.05):"
wc -l $OUTDIR/lwk_plink_ibd.genome

echo ""
echo "Top 10 most related pairs:"
sort -k10 -rn $OUTDIR/lwk_plink_ibd.genome | head -10