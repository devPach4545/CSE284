
#!/bin/bash

# =============================================================================

# run_germline.sh
# CSE 284 - PLINK vs GERMLINE IBD Analysis
# Converts data to VCF, phases with BEAGLE, and runs GERMLINE IBD detection
# Output goes to ~/ibd_project/data/
#
# Prerequisites (must be done before running this script):
#   1. GERMLINE compiled at ~/GERMLINE/germline
#      git clone https://github.com/gusevlab/germline.git ~/GERMLINE && cd ~/GERMLINE && make
#   2. BEAGLE downloaded at ~/ibd_project/beagle.jar
#      wget https://faculty.washington.edu/browning/beagle/beagle.22Jul22.46e.jar -O ~/ibd_project/beagle.jar
#   3. HapMap genetic map at ~/ibd_project/plink.chr22.GRCh37.map
#      wget https://bochet.gcc.biostat.washington.edu/beagle/genetic_maps/plink.GRCh37.map.zip -O ~/ibd_project/genetic_map.zip
#      cd ~/ibd_project && unzip genetic_map.zip
# =============================================================================


DATADIR=~/ibd_project/data
BEAGLE=~/ibd_project/beagle.jar
GENMAP=~/ibd_project/plink.chr22.GRCh37.map
GERMLINE=~/GERMLINE/germline

# Verify prerequisites
echo "============================================"
echo "Checking prerequisites..."
echo "============================================"

if [ ! -f "$GERMLINE" ]; then
    echo "ERROR: GERMLINE not found at $GERMLINE"
    echo "Run: git clone https://github.com/gusevlab/germline.git ~/GERMLINE && cd ~/GERMLINE && make"
    exit 1
fi

if [ ! -f "$BEAGLE" ]; then
    echo "ERROR: BEAGLE not found at $BEAGLE"
    echo "Run: wget https://faculty.washington.edu/browning/beagle/beagle.22Jul22.46e.jar -O ~/ibd_project/beagle.jar"
    exit 1
fi

if [ ! -f "$GENMAP" ]; then
    echo "ERROR: Genetic map not found at $GENMAP"
    echo "Run: wget https://bochet.gcc.biostat.washington.edu/beagle/genetic_maps/plink.GRCh37.map.zip -O ~/ibd_project/genetic_map.zip"
    echo "     cd ~/ibd_project && unzip genetic_map.zip"
    exit 1
fi

echo "All prerequisites found. Proceeding..."
echo ""

# Step 1: Convert pruned binary files to VCF for BEAGLE
echo "============================================"
echo "Step 1: Converting to VCF for BEAGLE..."
echo "============================================"
plink \
    --bfile $DATADIR/lwk_chr22_pruned \
    --recode vcf \
    --out $DATADIR/lwk_chr22_pruned

echo ""

# Step 2: Phase with BEAGLE using genetic map
echo "============================================"
echo "Step 2: Phasing with BEAGLE..."
echo "============================================"
java -jar $BEAGLE \
    gt=$DATADIR/lwk_chr22_pruned.vcf \
    map=$GENMAP \
    out=$DATADIR/lwk_chr22_phased_map

echo ""

# Step 3: Convert phased VCF back to ped/map with numeric alleles
echo "============================================"
echo "Step 3: Converting phased VCF to ped/map..."
echo "============================================"
plink \
    --vcf $DATADIR/lwk_chr22_phased_map.vcf.gz \
    --recode 12 \
    --out $DATADIR/lwk_chr22_phased_map

echo ""

# Step 4: Run GERMLINE
# Note: Uses phased ped + original pruned map (which has correct cM values)
# The phased map file has all zeros in the cM column so we use the original
echo "============================================"
echo "Step 4: Running GERMLINE..."
echo "============================================"
$GERMLINE \
    -input /home/$USER/ibd_project/data/lwk_chr22_phased_map.ped \
            /home/$USER/ibd_project/data/lwk_chr22_pruned.map \
    -output /home/$USER/ibd_project/data/lwk_germline_final \
    -min_m 1.0 \
    -err_hom 4 \
    -err_het 4 \
    -h_extend \
    -w_extend

echo ""
echo "============================================"
echo "GERMLINE complete."
echo "Output: $DATADIR/lwk_germline_final.match"
echo "============================================"

echo ""
echo "Quick summary:"
echo "Total IBD segments found:"
wc -l $DATADIR/lwk_germline_final.match

echo ""
echo "Segments:"
cat $DATADIR/lwk_germline_final.match