# CSE 284: PLINK vs GERMLINE: IBD-Based Relatedness Detection
## Team members: Dhaivat Pachchigar, Harsh Sharma, Sharanya Ranka

## Project Overview

This is an analysis project comparing two bioinformatics tools for detecting identity-by-descent (IBD) and inferring relatedness between individuals:
We have decided to work on option 2 where we are doing an analysis project comparing Plink and Germline for detecting IBD and inferring relatedness between individuals:

- **PLINK** (`--genome`): Produces pairwise relatedness statistics, most importantly PI_HAT, which estimates the overall proportion of the genome shared IBD between two individuals.
- **GERMLINE**: A segment-based IBD detection tool that identifies shared haplotype segments between pairs of individuals, summarized as total IBD length (%), segment count, and max segment length.

The goal is not to declare one tool better than the other, but to characterize where they agree and disagree, understand the reasons behind disagreements, and identify the practical strengths and weaknesses of each approach.
Another note, we are also not trying to predict how two individuals are related, since individuals can have the same IBDs but their relationship would be different.

---

## Dataset

We use the LWK (Luhya from Kenya) population subset from the 1000 Genomes Project, preprocessed into PLINK binary format. The dataset is mainly the ps2 dataset we already used. 

**Files (on datahub at `~/public/ps2/ibd/`):**
- `ps2_ibd.lwk.bed`
- `ps2_ibd.lwk.bim`
- `ps2_ibd.lwk.fam`

To keep compute manageable, all analyses are scoped to **chromosome 22**.

---

## Repository Structure

```
.
├── README.md
├── scripts/
│   ├── preprocess.sh       # QC filters, LD pruning, subset to chr22
│   ├── run_plink.sh        # Runs PLINK --genome on processed data
│   └── run_germline.sh     # Runs GERMLINE on processed data
└── notebooks/
    └── analyze.ipynb       # Correlation analysis, visualizations, cluster comparison
```

---

## How to Run

> All scripts assume you are running on the course datahub with access to the dataset path above.

### Step 1: Preprocess
```bash
bash scripts/preprocess.sh
```
This filters variants by missingness, MAF, and Hardy-Weinberg equilibrium, then performs LD pruning and subsets to chr22.

### Step 2: Run PLINK
```bash
bash scripts/run_plink.sh
```
Outputs a `.genome` file containing PI_HAT, Z0, Z1, Z2 for all sample pairs.

### Step 3: Run GERMLINE
```bash
bash scripts/run_germline.sh
```
Outputs a `.match` file containing shared IBD segments per pair.

### Step 4: Analysis and Visualization
Open and run `notebooks/analyze.ipynb` to reproduce all figures and comparisons.

---

## Evaluation Plan

### Lower-Level Metric Comparison
- Compute % shared IBD length from GERMLINE output (normalized to chr22 length)
- Correlate PI_HAT (PLINK) vs % shared IBD length (GERMLINE) using Pearson and Spearman correlation
- Scatter plot of the two metrics across all pairs

### Relationship Degree Binning
Bin each flagged pair into a relationship category based on expected IBD values:

| Relationship | Expected PI_HAT | Expected % IBD |
|---|---|---|
| Parent-Child / Full Siblings | ~0.50 | ~50% |
| Half Siblings / Grandparent | ~0.25 | ~25% |
| First Cousins | ~0.125 | ~12.5% |
| Unrelated | ~0 | ~0% |

Compare whether both tools assign the same relationship degree to the same pairs.

### Cluster-Level Comparison
Rather than only comparing pairs, cluster related individuals into family-like groups using each tool's output independently, then compare cluster structure between tools.

### Parameter Sensitivity
Vary PI_HAT thresholds (PLINK) and minimum segment length (GERMLINE) to measure how sensitive each tool's calls are to parameter choices.

### Performance Benchmarking
Record runtime and peak memory usage for both tools on chr22.

---

## Results So Far

- [ ] Preprocessing pipeline complete
- [ ] PLINK run complete
- [ ] GERMLINE run complete
- [ ] Correlation analysis complete
- [ ] Cluster comparison complete

*(This section will be updated as results come in)*

---

## Remaining Work and Challenges

### Remaining Work
- Finish writing and testing `preprocess.sh`, `run_plink.sh`, `run_germline.sh` on datahub
- Run GERMLINE and confirm output format is parseable
- Complete `analyze.ipynb` with all figures (correlation scatter plot, confusion matrix of relationship bins, cluster network visualization)
- Interpret disagreement cases: pairs flagged by one tool but not the other
- Write up final summary of strengths and weaknesses

### Challenges to Discuss
- **No ground truth**: The 1000 Genomes LWK dataset does not contain known related individuals, so we cannot evaluate accuracy in the traditional sense. Our approach is to use the expected PI_HAT / % IBD thresholds per relationship degree as a proxy, and to measure tool agreement rather than absolute accuracy.
- **GERMLINE setup**: Installing and running GERMLINE correctly on datahub, and making sure phased input is formatted properly.
- **Cluster definition**: It is not obvious what threshold or algorithm to use to define clusters from pairwise relatedness scores. We need to decide on a method (e.g. connected components at a given threshold) that is consistent across both tools.
- **Normalizing IBD length**: Choosing the right denominator when computing % shared IBD from GERMLINE (genetic length of chr22 vs. total covered length in the data).
