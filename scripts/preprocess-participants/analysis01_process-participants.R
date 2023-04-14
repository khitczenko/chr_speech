# analysis01_preprocess-participants
library("dplyr")

# setwd("/Users/kasia/Documents/Research/nu/ddk-participant-analyses/scripts")

# Read in data & get rid of files missing data for now
data_summary <- read.csv("../data/final-part-measures.csv")
data_summary <- subset(data_summary, is.na(avg_vot_duration) == FALSE)

## Begin by adding in participant IDs & group status (CHR: starts with 3 vs. HC: starts with 4)
for (i in 1:nrow(data_summary)) {
  partid <- substr(data_summary[i,'file'], 1,4)
  data_summary[i,'participant'] <- partid
  data_summary[i,'part_grp'] <- ifelse(startsWith(partid, '4'), 'hc', 'chr')
  data_summary[i,'subtask'] <- ifelse(grepl('SpeechA2', data_summary[i,'file'], fixed = TRUE), 'smr', 'amr')
}

# Handle data exclusions + one special case where a HC participant ended up being CHR
parts_to_remove <- c('4033', '3043', '3122')
## parts_to_remove <- c(parts_to_remove, '3046', '3069')
data_summary <- subset(data_summary, !(participant %in% parts_to_remove))
data_summary$part_grp[data_summary$participant == '4097'] <- 'chr'

# Add logged values
data_summary$log_coeffvar_vot_duration <- log(data_summary$coeffvar_vot_duration)
data_summary$log_coeffvar_vowel_duration <- log(data_summary$coeffvar_vowel_duration)
data_summary$log_coeffvar_syll_duration <- log(data_summary$coeffvar_syll_duration)
data_summary$log_coeffvar_intersyll_duration <- log(data_summary$coeffvar_intersyll_duration)
data_summary$log_coeffvar_ddk_rate <- log(data_summary$coeffvar_ddk_rate)

# Update part_grp names
data_summary$part_grp[data_summary$part_grp == "chr"] <- "Clinical High-Risk"
data_summary$part_grp[data_summary$part_grp == "hc"] <- "Healthy Controls"

write.csv(data_summary, "../../speech-in-chr-paper/data/preprocessed-analysis-input-ddk.csv", quote = FALSE, row.names = FALSE)
## write.csv(data_summary, "../../speech-in-chr-paper/data/preprocessed-analysis-input-partsrm-ddk.csv", quote = FALSE, row.names = FALSE)


