###################################################
#
#
# Extract channel with higher amplitude for all .wav files in directory
# 
# 12/6/21 based on MC script
# 
####################################################


# Load in sounds
directory$ = chooseDirectory$ ("Choose the directory containing sound files")
directory$ = "'directory$'" + "/" 


Create Strings as file list... list 'directory$'*.wav
number_files = Get number of strings


##########  LOAD IN ALL THE FILES ########## 
for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	s = Read from file... 'directory$''sound$'

	number_channels = Get number of channels

	if number_channels > 1
		channel1 = Extract one channel... 1
		ch1_intensity = Get intensity (dB)
		selectObject: s
		channel2 = Extract one channel... 2
		ch2_intensity = Get intensity (dB)
		if ch2_intensity > ch1_intensity
			selectObject: channel2
			appendInfoLine: sound$
		else
			selectObject: channel1
		endif
		Write to WAV file... 'directory$''sound$'
		removeObject: channel1
		removeObject: channel2
		removeObject: s
	endif
endfor
select all
Remove
