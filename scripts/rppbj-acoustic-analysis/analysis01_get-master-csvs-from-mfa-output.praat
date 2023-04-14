## Clear anything that's been done before
clearinfo

## Set directories
textgrid_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/data_chr/mfa-output-pbj-tg/"
datafile_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/pbj-speech-measures/"
textgrid_file_extension$ = ".TextGrid"

# Get a listing of all the sound files in textgrid_directory
list = Create Strings as file list: "list", "'textgrid_directory$'/*.TextGrid"
number = Get number of strings

# Create aggregated results .csv file in the datafile directory
# If the corresponding .phn file exists, start over
deleteFile(datafile_directory$ + "vowels-raw.csv")
deleteFile(datafile_directory$ + "phrases-raw.csv")
resultfile$ = datafile_directory$ + "vowels-raw.csv"
resultline$ = "file,seg_type,seg_start,seg_end,seg_duration,word,word_start,word_end 'newline$'"
fileappend "'resultfile$'" 'resultline$'
phraseresultfile$ = datafile_directory$ + "phrases-raw.csv"
phraseresultline$ = "file,seg_type,seg_start,seg_end,seg_duration,nsylls,word_num 'newline$'"
fileappend "'phraseresultfile$'" 'phraseresultline$'

# Loop through textgrids in textgrid_directory
for i to number
	selectObject: list
	filename$ = Get string... i
	name$ = filename$ - "'textgrid_file_extension$'"

	# Read this textgrid file
	tg_file = Read from file: textgrid_directory$ + filename$

	# Get how many intervals are on the last tier of this textgrid file
	nInterval = Get number of intervals: 2

	# Loop through intervals
	for j to nInterval

		# Get the label and only do stuff if we're looking at a labeled interval
		.label$ = Get label of interval: 2,j
		.last$ = right$ (.label$, 1)
		if .last$ == "1"

			# Get start time, end time, and label of Vowel
			.start = Get start time of interval: 2,j
			.end = Get end time of interval: 2,j
			.dur = .end - .start
			wordInt = Get interval at time: 1, (.start + .end)/2
			.word$ = Get label of interval: 1, wordInt
			.word_start = Get start time of interval: 1,wordInt
			.word_end = Get end time of interval: 1,wordInt


			resultline$ = "'name$', '.label$', '.start', '.end', '.dur', '.word$', '.word_start', '.word_end' 'newline$'"
			fileappend "'resultfile$'" 'resultline$'

		endif
	endfor

	# Get how many intervals are on the first (word) tier of this textgrid file
	nInterval = Get number of intervals: 1

	# Keep track of number of words
	.word_num = 0

	# Loop through intervals
	for j to nInterval

		# Get the label and only do stuff if we're looking at a labeled interval
		.label$ = Get label of interval: 1,j
		# Get start time, end time, and label of Vowel
		.start = Get start time of interval: 1,j
		.end = Get end time of interval: 1,j
		.dur = .end - .start

		first_phone_int = Get high interval at time: 2,.start
		last_phone_int = Get low interval at time: 2,.end
		.nsyll = 0

		for k from first_phone_int to last_phone_int
			.phone_label$ = Get label of interval: 2,k
			.first$ = left$ (.phone_label$, 1)
			if .first$ == "A" or .first$ == "E" or .first$ == "I" or .first$ == "O" or .first$ == "U"
				.nsyll = .nsyll + 1
			endif
		endfor

		.word_num = .word_num + 1
		if .label$ == ""
			.label$ = "XXXXX"
			.word_num = .word_num - 1
		endif

		phraseresultline$ = "'name$', '.label$', '.start', '.end', '.dur', '.nsyll', '.word_num' 'newline$'"
		fileappend "'phraseresultfile$'" 'phraseresultline$'

	endfor

removeObject: tg_file
endfor

removeObject: list
appendInfoLine: "Done!"