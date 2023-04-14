import pandas as pd
import numpy as np

# Code for extracting formant information
# analysis02_get-master-csv-from-fasttrack-output.py
# - file
# - seg_type
# - seg_start
# - seg_end
# - seg_duration
# - f1-20
# - f2-20
# - f3-20
# - f1-50
# - f2-50
# - f3-50
# - f1-80
# - f2-80
# - f3-80

# # Given a time, value, find the closest row
# # Return index of that row (note: 0 is the first non-header row!!!)
def find_closest_row(value, rows):
	return(np.argmin(abs(np.array(rows)-value)))

# list of directories containing formant values we want to extract
# list_of_directories = ['../FastTrack/Fast Track/chr-ddk-data/female/','../FastTrack/Fast Track/chr-ddk-data/male/']
list_of_directories = ['../FastTrack/Fast Track/chr-ddk-data/female/','../FastTrack/Fast Track/chr-ddk-data/male/']#,
						# '../FastTrack/Fast Track/chr-ddk-data/female2/','../FastTrack/Fast Track/chr-ddk-data/male2/',
						# '../FastTrack/Fast Track/chr-ddk-data/female3/','../FastTrack/Fast Track/chr-ddk-data/male3/']


formant_master = []

for directory in list_of_directories:
	seg_info = pd.read_csv(directory + 'segmentation_information.csv')
	file_dur_pairs = list(zip(seg_info['outputfile'].tolist(), seg_info['duration'].tolist()))

	for ii in range(0, len(file_dur_pairs)):

		if file_dur_pairs[ii][0] == '--' or file_dur_pairs[ii][0] == '-':
			continue

		formant_file = pd.read_csv(directory + 'csvs/' + file_dur_pairs[ii][0] + '.csv')
		
		index20 = find_closest_row(0.2*file_dur_pairs[ii][1]+0.025, np.array(formant_file['time']))
		index50 = find_closest_row(0.5*file_dur_pairs[ii][1]+0.025, np.array(formant_file['time']))
		index80 = find_closest_row(0.8*file_dur_pairs[ii][1]+0.025, np.array(formant_file['time']))

		this_line = [file_dur_pairs[ii][0],
					formant_file.iloc[index20]['f1'], 
					formant_file.iloc[index20]['f2'], 
					formant_file.iloc[index20]['f3'],
					formant_file.iloc[index50]['f1'],
					formant_file.iloc[index50]['f2'],
					formant_file.iloc[index50]['f3'],
					formant_file.iloc[index80]['f1'],
					formant_file.iloc[index80]['f2'],
					formant_file.iloc[index80]['f3']]

		formant_master.append(this_line)

# Make dataframe that will hold all information above and will be output
# by combining the "segmentation_information" files from each directory.
seg_info = pd.read_csv(list_of_directories[0] + 'segmentation_information.csv')
for directory in list_of_directories[1:]:
	additional_seg_info = pd.read_csv(directory + 'segmentation_information.csv')
	seg_info = pd.concat([seg_info, additional_seg_info])

header = ['formantfile', 'f1.20', 'f2.20', 'f3.20', 'f1.50', 'f2.50', 'f3.50', 'f1.80', 'f2.80', 'f3.80']
formant_master = pd.DataFrame(formant_master, columns = header)

# Merge seg_info and formant_master
info_to_output = pd.merge(seg_info, formant_master, how = 'left', left_on = 'outputfile', right_on = 'formantfile')
info_to_output = info_to_output.drop(columns=['previous_sound', 'next_sound', 'omit', 'interval', 'formantfile'])

# # # Output dataframe
info_to_output.to_csv('../ddk-speech-measures/fasttrack_raw.csv', index = False)
