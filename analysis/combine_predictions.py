import csv
from decimal import *

IN_ROOT = "../output/"
IN_FILE_NAMES = (
"odms-matches.csv",
"odms-matches-bivpois.csv",
"odms-matches-bivpois-odmiter1.csv",
"odms-matches-odmiter1.csv",
"odms-matches-softmax.csv",
"odms-matches-softmax-diff.csv",
"odms-matches-softmax-diff-odmiter1.csv",
"odms-matches-softmax-geomdiff-odmiter1.csv",
"odms-matches-softmax-geomdiff.csv",
"odms-matches-softmax-nonmov-odmiter1.csv",
"odms-matches-softmax-nonmov.csv",
"odms-matches-softmax-odmiter1.csv",
)

OUT_ROOT = "./output/"
CSV_HEADER = (
	"HomeTeam",
	"AwayTeam",
	"Date",
	"Contest",
	"HomeGoals",
	"AwayGoals",
	"HomeGoalsFull",
	"AwayGoalsFull",
	"ExtraTimePossible",
	"HomeAdvantage",
	"HomeStrAgg",
	"AwayStrAgg",
	"HomeStrAggNext",
	"AwayStrAggNext",
	"HomeWin",
	"Tie",
	"AwayWin",
	"SSE")

COLUMNS_TO_COLLECT = (
	"HomeWin",
	"Tie",
	"AwayWin"
)

SUM_TO_ONE_TOLERANCE = .001

# "HomeTeam":0, "AwayTeam":1, etc
M = {CSV_HEADER[i]:i for i in range(len(CSV_HEADER))}

outputs = {colname:[] for colname in COLUMNS_TO_COLLECT}

for filenum in range(len(IN_FILE_NAMES)):
	filename = IN_FILE_NAMES[filenum]
	with open(IN_ROOT + filename,'r', encoding='windows-1252') as csvfile:
		reader = csv.reader(csvfile, delimiter=',', quotechar='"')
		this_csv_header = None
		datarow_ind = 0
		for row in reader:
			assert len(row) == len(CSV_HEADER)
			if not this_csv_header:
				# just to check that they all have the expected header
				this_csv_header = row
				assert tuple(this_csv_header) == CSV_HEADER
			else:
				for col in COLUMNS_TO_COLLECT:					
					if datarow_ind > len(outputs[col]) - 1:
						outputs[col].append([])
					outputs[col][datarow_ind].append(row[M[col]])

				predict_sum = sum(Decimal(outputs[col][datarow_ind][-1]) for col in COLUMNS_TO_COLLECT)
				if abs(1 - predict_sum) > SUM_TO_ONE_TOLERANCE:
					print("Filename {}, row {} predictions only summed to {}".format(filename, datarow_ind, predict_sum))
				

				datarow_ind += 1

	for col in COLUMNS_TO_COLLECT:
		with open(OUT_ROOT + col + ".csv", 'w', encoding='windows-1252') as out_file:
			out_file.writelines((",".join(row) + "\n" for row in outputs[col]))



