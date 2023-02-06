<p align="middle">
<img width="200" height="180" src="resources/logo.jpg">
</p>
# CPHL-SARs-CoV Genomics Bioinformatics Pipeline

## 📝 Description

This pipeline is intended to call variants, build consensus genomes and determine both nextclade and pangolin lineages

## ⚙️ Installation

- Install [Miniconda](https://conda.io/miniconda.html) by running the following commands:

`cd ~`

**For Linux Users:** `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`  
`bash Miniconda3-latest-Linux-x86_64.sh`

**For MacOS Users:** `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh`
`bash Miniconda3-latest-MacOSX-x86_64.sh`

- Export miniconda into the PATH using `export PATH=~/miniconda3/bin:$PATH`

Install _**Mamba Package Manager**_ for faster installation & environment resolution:   
`conda install -c conda-forge -y mamba`
`conda update -n base -c defaults conda`

- Clone this repository using `git clone https://github.com/Kanyerezi30/CPHL_SARs_CoV.git`
- Change to this directory using `cd CPHL_SARs_CoV`
- Install using `mamba env create -n sarscov --file dependencies.yml`

## 📀 Usage

Execute the program using `bash cov19.sh`

### ✍️ Authors

- [Stephen Kanyerezi](https://github.com/Kanyerezi30)
- [Ivan Sserwadda](https://github.com/GunzIvan28)

### 🐛 To report bugs, ask questions or seek help

The software developing team works round the clock to ensure the bugs within the program are captured and fixed. For support or any inquiry, you can submit your query using the [Issue Tracker](https://github.com/Kanyerezi30/CPHL_SARs_CoV/issues)

<p align="middle">
<img width="200" height="180" src="resources/logo.jpg">
</p>
