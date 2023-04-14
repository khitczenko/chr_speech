## Clear anything that's been done before
clearinfo

## Set directories
# textgrid_directory should be set to the directory where the DDKtor output is
textgrid_directory$ = "../data_chr/ddktor-output-tg/"
# datafile_directory should be set to wherever you'd like the measures to be output
datafile_directory$ = "../ddk-speech-measures/"

# Get a listing of all the sound files in textgrid_directory
list = Create Strings as file list: "list", "'textgrid_directory$'/*.TextGrid"
number = Get number of strings

# Create aggregated results .csv file in the datafile directory
# If the .csv file already exists, start over
deleteFile(datafile_directory$ + "ddktor_raw.csv")
resultfile$ = datafile_directory$ + "ddktor_raw.csv"
resultline$ = "file,seg_type,seg_start,seg_end,seg_duration,window_type,window_start,window_end 'newline$'"
fileappend "'resultfile$'" 'resultline$'

# Loop through textgrids in textgrid_directory
for i to number
	selectObject: list
	filename$ = Get string... i
	name$ = filename$ - ".TextGrid"

	# Read this textgrid file
	tg_file = Read from file: textgrid_directory$ + filename$

	# Get the last tier
	lastTier = Get number of tiers

	# Get how many intervals are on the last tier of this textgrid file
	nInterval = Get number of intervals: lastTier

	# Loop through intervals
	for j to nInterval

		# Get the label and only extract extra info if we're dealing with a labeled interval
		.label$ = Get label of interval: lastTier,j
		if .label$ <> ""

			# Get start time, end time, and label
			.start = Get start time of interval: lastTier,j
			.end = Get end time of interval: lastTier,j
			.dur = .end - .start
			windowInt = Get interval at time: 1, (.start + .end)/2
			.window$ = Get label of interval: 1, windowInt
			.window_start = Get start time of interval: 1, windowInt
			.window_end = Get end time of interval: 1, windowInt

			resultline$ = "'name$', '.label$', '.start', '.end', '.dur', '.window$', '.window_start', '.window_end' 'newline$'"
			fileappend "'resultfile$'" 'resultline$'

		endif
	endfor

removeObject: tg_file
endfor

removeObject: list
appendInfoLine: "Done!"