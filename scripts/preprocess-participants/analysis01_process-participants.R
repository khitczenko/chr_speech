# analysis01_preprocess-participants

# setwd("/Users/kasia/Documents/Research/nu/pbj-participant-analyses/scripts")

# Read in data & get rid of files missing data for now
data_summary <- read.csv("../data/final-pbj-speech-measures.csv")

## Begin by adding in participant IDs & group status (CHR: starts with 3 vs. HC: starts with 4)
for (i in 1:nrow(data_summary)) {
  partid <- substr(data_summary[i,'file'], 1,4)
  data_summary[i,'participant'] <- partid
  data_summary[i,'part_grp'] <- ifelse(startsWith(partid, '4'), 'hc', 'chr')
}

# Handle data exclusions + one special case where a HC participant ended up being CHR
parts_to_remove <- c('4033', '3043', '3122')
# parts_to_remove <- c(parts_to_remove, '3046', '3069') # run w/ and w/o
data_summary <- subset(data_summary, !(participant %in% parts_to_remove))
data_summary$part_grp[data_summary$participant == '4097'] <- 'chr'

# Update part_grp names
data_summary$part_grp[data_summary$part_grp == "chr"] <- "Clinical High-Risk"
data_summary$part_grp[data_summary$part_grp == "hc"] <- "Healthy Controls"

write.csv(data_summary, "../../speech-in-chr-paper/data/preprocessed-analysis-input-pbj.csv", quote = FALSE, row.names = FALSE)
# write.csv(data_summary, "../../speech-in-chr-paper/data/preprocessed-analysis-input-partsrm-pbj.csv", quote = FALSE, row.names = FALSE)


