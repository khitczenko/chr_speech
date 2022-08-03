## Clear anything that's been done before
clearinfo

## Set directory
textgrid_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/data_chr/mfa-output-rp-tg/"
output_textgrid_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/data_chr/input-to-autovot-rp-wavtg/"

## Get a list of all of the textgrid files in the directory
list = Create Strings as file list: "list", "'textgrid_directory$'/*.TextGrid"
number = do("Get number of strings")

## Loop through files, 

for s to number

	# Read in current file
	selectObject: list
	textgrid_filename$ = Get string: s
	tg$ = textgrid_directory$ + textgrid_filename$
	tg_file = Read from file: tg$

	# Add tier for vot-windows
	Insert interval tier: 3, "vot-windows"

	nIntervals = Get number of intervals: 2
	for i to nIntervals
		label$ = Get label of interval: 2, i
		if label$ == "P" or label$ == "B" or label$ == "T" or label$ == "D" or label$ == "K" or label$ == "G"

			start = Get start time of interval: 2, i
			end = Get end time of interval: 2, i

			# What is the word interval for the current sound
			word_at_current = Get interval at time: 1, (start+end)/2
			
			# Get previous sound midpoint
			prev_start = Get start time of interval: 2, i-1
			word_at_previous = Get interval at time: 1, (prev_start+start)/2
			
			next_sound_is_vowel = 0
			next_sound_label$ = Get label of interval: 2, i+1
			first_char_next_sound$ = left$ (next_sound_label$, 1)
			if first_char_next_sound$ == "A" or first_char_next_sound$ == "E" or first_char_next_sound$ == "I" or first_char_next_sound$ == "O" or first_char_next_sound$ == "U"
				next_sound_is_vowel = 1
			endif

			if word_at_current <> word_at_previous and next_sound_is_vowel == 1
			# if word_at_current <> word_at_previous

				# Check that it's okay to add boundary
				int_at_new_boundary = Get interval at time: 3, start-0.030
				label_at_new_boundary$ = Get label of interval: 3, int_at_new_boundary
				if label_at_new_boundary$ <> ""
					appendInfoLine: "Problem inserting boundary"
					appendInfoLine: textgrid_filename$
					appendInfoLine: start
					Remove right boundary: 3, int_at_new_boundary
				endif
				if label$ == "P" or label$ == "T" or label$ == "K"
					Insert boundary: 3, start-0.031
					Insert boundary: 3, end+0.031
				endif
				if label$ == "B" or label$ == "D" or label$ == "G"
					Insert boundary: 3, start-0.011
					Insert boundary: 3, end+0.011
				endif
				int_to_label = Get interval at time: 3, (start+end)/2
				Set interval text: 3, int_to_label, "window"
				# Set interval text: 3, int_to_label, label$
			endif
		endif
	endfor

	Save as text file: output_textgrid_directory$ + textgrid_filename$
	removeObject: tg_file

endfor
removeObject: list
appendInfoLine: "Done!"

		