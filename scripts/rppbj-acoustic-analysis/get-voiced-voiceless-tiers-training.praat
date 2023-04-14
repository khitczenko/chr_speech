## Clear anything that's been done before
clearinfo

## Set directories
textgrid_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/data_chr/training-data-for-autovot-rp/"

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
		Remove tier: 6
		Remove tier: 5
	endif

	# Add voiceless and voiced tiers
	Insert interval tier: 5, "voiceless-manual"
	Insert interval tier: 6, "voiced-manual"

	# Loop through intervals in 4th tier and copy to 5th or 6th depending on whether voiced or voiceless
	nIntervals = Get number of intervals: 4
	for i to nIntervals
		label$ = Get label of interval: 4,i
		if label$ <> ""
			start = Get start time of interval: 4,i
			end = Get end time of interval: 4,i
			if label$ == "P" || label$ == "T" || label$ == "K"
				Insert boundary: 5,start
				Insert boundary: 5,end
				currIntN = Get interval at time: 5,(start+end)/2
				Set interval text: 5,currIntN,"vot"
			endif
			if label$ == "B" || label$ == "D" || label$ == "G"
				Insert boundary: 6,start
				Insert boundary: 6,end
				currIntN = Get interval at time: 6,(start+end)/2
				Set interval text: 6,currIntN,"vot"
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