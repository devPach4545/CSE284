# CSE 284: PLINK vs. GERMLINE: IBD-Based Relatedness Detection

**Team Members:** Dhaivat Pachchigar, Harsh Sharma, Sharanya Ranka

## Project Overview

We have decided to work on option 2 where we are doing an analysis project comparing Plink and Germline for detecting IBD and inferring relatedness between individuals:

- **PLINK** (`--genome`): Produces pairwise relatedness statistics (We used this in ps2), most importantly PI_HAT, which estimates the overall proportion of the genome shared IBD between two individuals, it use pi_hat to find how closely related 2 individuals are.
- **GERMLINE**: A segment-based IBD detection tool that identifies shared haplotype segments between pairs of individuals

The goal is not to declare one tool better than the other but to characterize where they agree and disagree, understand the reasons behind disagreements, and identify the practical strengths and weaknesses of each approach.
Another note, we are also not trying to predict how two individuals are related, since individuals can have the same IBDs but their relationship would be different.

---

## Dataset

We use the LWK (Luhya from Kenya) population subset from the 1000 Genomes Project, preprocessed into PLINK binary format. The dataset is mainly the ps2 dataset we already used. We use this dataset because the 1000genome dataset doesn't have relationship among indiviuals. Though the current dataset doesn't have any official relationship, our findings using Plinnk were interesting. 

**Files (on datahub at `~/public/ps2/ibd/`):**
- `ps2_ibd.lwk.bed`
- `ps2_ibd.lwk.bim`
- `ps2_ibd.lwk.fam`

To keep compute manageable, all analyses are scoped to **chromosome 22**. We used this because it's used for benchmarking many tools in bioinformatics.  

---

## Repository Structure


---

## How to Run

This can only be run on datahub since the tools needed to replicate what we did are all available on datahub and writing installation for each
would be a pain since, it cannot be assumed that the person running will be using the same OS as us. 

### Step 0: installations
## Sanity check to make sure all files exists
```
which gcc        # C++ compiler needed to build GERMLINE
which java       # Java needed for BEAGLE
which plink      # PLINK needed for data conversion
gcc --version    # Should be gcc 9.x or later
java -version    # Should be OpenJDK 11 or later
plink --version  # Should be PLINK v1.90
```

1. First clone the repo
```
cd ~
git clone https://github.com/devPach4545/CSE284.git
cd CSE284
```


- now create an output directory this is where all the output will be stored irreepctive of where the repo is cloned:
```
mkdir -p ~/ibd_project/data
```

- Install germline

```
cd ~
git clone https://github.com/gusevlab/germline.git ~/GERMLINE
cd ~/GERMLINE
make
```

- In order to phase data, we download beagle

```
wget https://faculty.washington.edu/browning/beagle/beagle.22Jul22.46e.jar \
    -O ~/ibd_project/beagle.jar
```

- verify it downloaded

```
ls -lh ~/ibd_project/beagle.jar # should show around 295KB
```

- So we learned that need a genetic map of chr 22 in order to get correct genetic distances otherwise germline will assume 1 cM = 1Mb

```
wget https://bochet.gcc.biostat.washington.edu/beagle/genetic_maps/plink.GRCh37.map.zip \
    -O ~/ibd_project/genetic_map.zip
cd ~/ibd_project
unzip genetic_map.zip
cd ~
```

- verify it has chr 22

```
head ~/ibd_project/plink.chr22.GRCh37.map
![hapmap output](image.png)
```


- Now, time to run preprocessing script


```
cd ~/CSE284
bash scripts/preprocess.sh
```

- this will generate some .bed file

- Okay, we are ready to run plink
```
bash scripts/run_plink.sh
```

- You should see the outlike this below
![plink output](image-1.png)

## Good job if you made it so far,
Now, we will have to prepare to run germline. If you have installed everything we wrote above, 
you just need to run 

```
bash scripts/run_germline.sh
```

you should see top 5 pairs outputted by germline. 


## Finally, In order to run the analysis, we strongly recommend that you upload files in final_result_files and upload it to same directory where analyze.ipynb is (on datahub). This will help you run the notebook.
