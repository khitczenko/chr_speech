f = open("../librispeech-lexicon.txt", "r")
out = ""
fixed_files = []
for file in f.readlines():
	tmp = file.split()
	fixed_format = tmp[0] + '\t' + ' '.join(tmp[1:])
	fixed_files.append(fixed_format)
f.close()

with open('../librispeech-lexicon-out.txt', 'w') as out:
    for item in fixed_files:
        out.write("%s\n" % item)






