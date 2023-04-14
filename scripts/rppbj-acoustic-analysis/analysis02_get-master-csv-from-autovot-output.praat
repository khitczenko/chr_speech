## Clear anything that's been done before
clearinfo

## Set directories
textgrid_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/data_chr/autovot-output-pbj/"
datafile_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/pbj-speech-measures/"
textgrid_file_extension$ = ".TextGrid"

# Get a listing of all the sound files in textgrid_directory
list = Create Strings as file list: "list", "'textgrid_directory$'/*.TextGrid"
number = Get number of strings

# Create aggregated results .csv file in the datafile directory
# If the corresponding .phn file exists, start over
deleteFile(datafile_directory$ + "vots-raw.csv")
resultfile$ = datafile_directory$ + "vots-raw.csv"
resultline$ = "file,seg_type,seg_start,seg_end,seg_duration,mfa_duration,word,word_start,word_end 'newline$'"
fileappend "'resultfile$'" 'resultline$'

# Loop through textgrids in textgrid_directory
for i to number
	selectObject: list
	filename$ = Get string... i
	name$ = filename$ - "'textgrid_file_extension$'"

	# Read this textgrid file
	tg_file = Read from file: textgrid_directory$ + filename$

	# Get the last tier
	lastTier = Get number of tiers

	# Get how many intervals are on the last tier of this textgrid file
	nInterval = Get number of intervals: lastTier

	# Loop through intervals
	for j to nInterval

		# Get the label and only do stuff if we're looking at a labeled interval
		.label$ = Get label of interval: lastTier,j
		if .label$ <> ""

			# Get start time, end time, and label of VOT
			.start = Get start time of interval: lastTier,j
			.end = Get end time of interval: lastTier,j
			.dur = .end - .start
			wordInt = Get interval at time: 1, (.start + .end)/2
			.word$ = Get label of interval: 1, wordInt

			windowInt = Get interval at time: 3, (.start + .end)/2
			start_windowInt = Get start time of interval: 3, windowInt
			end_windowInt = Get end time of interval: 3, windowInt
			phoneInt = Get interval at time: 2, (start_windowInt + end_windowInt)/2
			wordInt = Get interval at time: 1, (start_windowInt + end_windowInt)/2
			.intended_phone$ = Get label of interval: 2, phoneInt
			.phone_start = Get start time of interval: 2, phoneInt
			.phone_end = Get end time of interval: 2, phoneInt
			.mfa_dur = .phone_end - .phone_start
			.intended_word$ = Get label of interval: 1, wordInt
			.word_start = Get start time of interval: 1, wordInt
			.word_end = Get end time of interval: 1, wordInt


			resultline$ = "'name$', '.intended_phone$', '.start', '.end', '.dur', '.mfa_dur', '.intended_word$', '.word_start', '.word_end' 'newline$'"
			fileappend "'resultfile$'" 'resultline$'

		endif
	endfor

removeObject: tg_file
endfor

removeObject: list
appendInfoLine: "Done!"