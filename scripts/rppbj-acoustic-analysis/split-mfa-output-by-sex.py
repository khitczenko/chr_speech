# Take files from data/out_tg and split them into data/out_tg_split-by-sex/female or data/out_tg_split-by-sex/male
# depending on whether they self-reported as male or female (info in participant_age-sex.csv)
import glob
import pandas as pd
import os
import shutil
# Look into shutil.move if you want to move things permanently

participant_sex = pd.read_csv('../../ddk-participant-analyses/data/participant-info-we-collected.xlsx - chr.csv')
# print(participant_sex)

# Note that if you're getting an error, check
# that you are using sep = ';' or not accordingly

partid2sex = {}
for i in range(0, len(participant_sex)):
	partid2sex[participant_sex['Participant'][i][0:4]] = participant_sex['Demo_Sex'][i]

# Loop through all files and copy based on whether M or F
mypath = "../data_chr/mfa-output-pbj-tg"
all_tgs_in_mypath = glob.glob(mypath + "/*.TextGrid")

for file in all_tgs_in_mypath:
	part_id = file.split('/')[-1][0:4]
	# part_sex = participant_sex.query('Participant==' + part_id)['Demo_Sex'].iloc[0]
	if part_id not in partid2sex:
		print("Missing sex information for participant " + part_id)
	else:
		# part_sex = int(partid2sex[part_id])
		part_sex = partid2sex[part_id]
		if part_sex == 1:
			shutil.copyfile(mypath + '/' + file.split('/')[-1], mypath + '-split-by-sex-input-to-fasttrack/female/' + file.split('/')[-1])
		elif part_sex == 2:
			shutil.copyfile(mypath + '/' + file.split('/')[-1], mypath + '-split-by-sex-input-to-fasttrack/male/' + file.split('/')[-1])
		else:
			print("Missing sex information for participant " + part_id)


# Loop through all files and copy based on whether M or F
mypath = "../data_chr/mfa-output-rp-tg"
all_tgs_in_mypath = glob.glob(mypath + "/*.TextGrid")

for file in all_tgs_in_mypath:
	part_id = file.split('/')[-1][0:4]
	# part_sex = participant_sex.query('Participant==' + part_id)['Demo_Sex'].iloc[0]
	if part_id not in partid2sex:
		print("Missing sex information for participant " + part_id)
	else:
		# part_sex = int(partid2sex[part_id])
		part_sex = partid2sex[part_id]
		if part_sex == 1:
			shutil.copyfile(mypath + '/' + file.split('/')[-1], mypath + '-split-by-sex-input-to-fasttrack/female/' + file.split('/')[-1])
		elif part_sex == 2:
			shutil.copyfile(mypath + '/' + file.split('/')[-1], mypath + '-split-by-sex-input-to-fasttrack/male/' + file.split('/')[-1])
		else:
			print("Missing sex information for participant " + part_id)




