## Clear anything that's been done before
clearinfo

## Set directories
textgrid_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/data_chr/input-to-autovot-pbj-wavtg/"

## Get a listing of all the sound files in the sound_directory
list = Create Strings as file list:  "list", "'textgrid_directory$'/*.TextGrid"
number = do("Get number of strings")

## Loop through files, add voiceless and voiced tiers
for s to number

	# Read in current human annotated file
	selectObject: list
	textgrid_filename$ = Get string: s
	tg$ = textgrid_directory$ + textgrid_filename$
	tg_file = Read from file: tg$

	# If file already has 6 tiers, delete the last two tiers so we can start over
	selectObject: tg_file
	nTiers = Get number of tiers
	if nTiers > 4
		exitScript: "Too many tiers!"
	endif

	# Add voiceless and voiced tiers
	Insert interval tier: 4, "voiceless-windows"
	Insert interval tier: 5, "voiced-windows"

	# Loop through intervals in 3rd tier and copy to 4th or 5th depending on whether voiced or voiceless
	nIntervals = Get number of intervals: 3
	prev_voiceless = 0
	prev_voiced = 0
	for i to nIntervals
		start = Get start time of interval: 3,i
		end = Get end time of interval: 3,i
		currIntN_tiertwo = Get interval at time: 2,(start+end)/2
		label$ = Get label of interval: 2,currIntN_tiertwo
		win_label$ = Get label of interval: 3,i
		if win_label$ <> ""
			if label$ == "P" || label$ == "T" || label$ == "K"
				if start <> prev_voiceless
					Insert boundary: 4,start
				endif
				Insert boundary: 4,end
				currIntN = Get interval at time: 4,(start+end)/2
				Set interval text: 4,currIntN,label$
				prev_voiceless = end
			endif
			if label$ == "B" || label$ == "D" || label$ == "G"
				if start <> prev_voiced
					Insert boundary: 5,start
				endif
				Insert boundary: 5,end
				currIntN = Get interval at time: 5,(start+end)/2
				Set interval text: 5,currIntN,label$
				prev_voiced = end
			endif
		endif		
	endfor

	# Save file
	selectObject: tg_file
	Save as text file: tg$

	removeObject: tg_file

endfor
removeObject: list
appendInfoLine: "Done!"