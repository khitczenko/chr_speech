## Clear anything that's been done before
clearinfo

## Set directories
textgrid_directory$ = "/Users/kasia/Documents/Research/nu/rppbj-automatic-acoustic-analysis/data_chr/autovot-output-pbj/"

## Get a listing of all the sound files in the sound_directory
list = Create Strings as file list:  "list", "'textgrid_directory$'/*.TextGrid"
number = do("Get number of strings")

## Loop through files, add voiceless and voiced tiers
for s to number

	# Read in current file
	selectObject: list
	textgrid_filename$ = Get string: s
	tg$ = textgrid_directory$ + textgrid_filename$
	tg_file = Read from file: tg$

	# Loop through intervals in 7th tier and copy to 6th
	selectObject: tg_file
	nIntervals = Get number of intervals: 7
	for i to nIntervals
		label$ = Get label of interval: 7,i
		if label$ <> ""
			start = Get start time of interval: 7,i
			end = Get end time of interval: 7,i
			Insert boundary: 6,start
			Insert boundary: 6,end
			currIntN = Get interval at time: 6,(start+end)/2
			Set interval text: 6,currIntN,label$	
		endif		
	endfor
	Remove tier: 7

	# Save file
	selectObject: tg_file
	Save as text file: tg$

	removeObject: tg_file

endfor
removeObject: list
appendInfoLine: "Done!"