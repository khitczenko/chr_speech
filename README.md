# Code for "Speech characteristics yield important clues about motor function: Speech variability in individuals at clinical high-risk for psychosis"

For now, this directory contains the analysis scripts for the submitted paper. 
- scripts/ddk-acoustic-analysis/: The scripts in this directory work together to go from the output of DDKtor and FastTrack to yield the speech measures analyzed in the paper.
- scripts/rppbj-acoustic-analysis/: The scripts in this directory work together to go from the output of the Montreal Forced Aligner, AutoVOT, and FastTrack to yield the speech measures analyzed in the paper.
- paper/: The two RMarkdown files in this folder take the outputs of both ddk-acoustic-analysis/ and rppbj-acoustic-analysis/ and create the paper.

Upon acceptance, speech measure data (i.e., the input to the paper RMarkdown files, which is also the output of ddk-acoustic-analysis and rppbj-acoustic-analysis), as well as DDKtor, FastTrack, AutoVOT output files will be provided to ensure reproducibility. The National Institute of Mental Health Data Archive provides de-identified clinical, risk, and demographic information.

Please reach out to Kasia Hitczenko with any questions.
