# Code for "Speech characteristics yield important clues about motor function: Speech variability in individuals at clinical high-risk for psychosis"

This directory contains the data and analysis scripts for the paper. 
- scripts/ddk-acoustic-analysis/: The scripts in this directory work together to go from the output of DDKtor and FastTrack to yield the diadochokinetic speech measures analyzed in the paper.
- scripts/rppbj-acoustic-analysis/: The scripts in this directory work together to go from the output of the Montreal Forced Aligner, AutoVOT, and FastTrack to yield both the read and spontaneous speech measures analyzed in the paper.
- paper/: The two RMarkdown files in this folder take the outputs of both ddk-acoustic-analysis/ and rppbj-acoustic-analysis/ (which are in the data/ subdirectory) and create the paper (main.Rmd) and supplementary material (supmat.Rmd) files.
- data/: This directory contains all speech measure data necessary to reproduce the paper. Note: we do not publicly release the clinical data used (participant-info-we-collected.xlsx - chr.csv). The National Institute of Mental Health Data Archive provides this de-identified clinical, risk, and demographic information, or feel free to reach out to Kasia Hitczenko.

Please reach out to Kasia Hitczenko with any questions.
