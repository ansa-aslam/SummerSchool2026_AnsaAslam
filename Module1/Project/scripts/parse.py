#__________________STEP 2______________________
#______________FASTA SEQ COUNT+GC______________

from Bio import SeqIO
import pandas as pd

def parse_fasta(file):
    seq_count = 0
    gc_total = 0

    for record in SeqIO.parse(file, "fasta"):
        seq = str(record.seq)
        gc = ((seq.count("G") + seq.count("C")) / len(seq)) * 100

        gc_total += gc
        seq_count += 1

    average_gc = gc_total / seq_count

    print("Total sequences:", seq_count)
    print("Average GC content:", average_gc)
    return seq_count, average_gc

seq_count, average_gc = parse_fasta("raw/genes.fasta")

summary_1 = pd.DataFrame({
    "Total Sequences": [seq_count],
    "Average GC Content": [average_gc]
})

summary_1.to_csv("results/fasta_summary.csv", index=False)

#__________FASTQ read count+mean quality+QC pass count_________

reads = 0
mean_qualities = []
passed = 0

for record in SeqIO.parse("raw/sample_reads.fastq", "fastq"):
    reads += 1
    mean_q = sum(record.letter_annotations["phred_quality"]) / len(record)
    mean_qualities.append(mean_q)

    if mean_q >= 30:
        passed += 1

overall_mean_quality = sum(mean_qualities) / len(mean_qualities)

print(f'Reads: {reads}, Mean Quality: {round(overall_mean_quality, 2)}, QC Passed: {passed}')

summary_2 = pd.DataFrame({
    "Reads":[reads], "Mean_Quality":[round(overall_mean_quality, 2)], "QC_Passed":[passed]
    })

summary_2.to_csv("results/fastq_summary.csv", index=False)

#_____________GFF3: feature counts______________
feature_counts = {}

with open("raw/annotations.gff3") as file:
    for line in file:
        if line.startswith("#"):
            continue

        feature = line.split("\t")[2]
        feature_counts[feature] = feature_counts.get(feature,0)+1

summary_3 = pd.DataFrame(
    feature_counts.items(),
    columns=["Feature","Count"]
)
summary_3.to_csv("results/gff_summary.csv", index=False)

#_____________VCF: variant counts______________
variants = 0

with open("raw/variants.vcf") as file:
    for line in file:
        if not line.startswith("#"):
            variants += 1

summary_4 = pd.DataFrame({
    "Variants":[variants]
})

summary_4.to_csv("results/vcf_summary.csv",index=False)

