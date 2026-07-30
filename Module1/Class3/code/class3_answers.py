#----------------------
#     Question 5    
#----------------------
gc = 52.47

if gc>60:
  print('GC-rich')
else:
  print('Average GC')

#----------------------
#     Question 6     
#----------------------

seq="ATGCGGTA"

for i in seq:
  print(i.lower())


#----------------------
#     Question 7      
#----------------------

i=5

while i>=1:
  print(i)
  i-=1


#----------------------
#     Question 8    
#----------------------
def gc_content(seq):
  gc_percentage= ((seq.count('G')+seq.count('C'))/len(seq))*100
  print(f'The GC content is {gc_percentage}%')

gc_content("GGGGCCCCAAAATTTT")

#----------------------
#     Question 9  
#----------------------
def reverse_complement(seq):
  pair={'A':'T','T':'A','G':'C','C':'G'}
  complement=[]

  for i in seq:
    complement.append(pair[i])

  print(complement)

seq1="AAAACGT"
reverse_complement(seq1)

#----------------------
#     Question 10   
#----------------------
def base_counts(seq):
  count={'A': 0, 'T': 0, 'G': 0, 'C': 0}

  for i in seq:
      count[i]+=1

  print(count)

seq1 = "AATTGGCC"
base_counts(seq1)


#----------------------
#     Question 11   
#----------------------
a=["thrA", "lacZ", "recA", "rpoB"]

a.append('gyrA')

print(f'The length of the gene is {len(a)}')
print(f'The last gene is {a[-1]}')

#----------------------
#     Question 12    ############# 
#----------------------
with open('../../data/genes.fasta', "r") as file:
  fasta = file.read()


seq_count=0
#How many sequences it contains
for i in fasta:
  if i == '>':
    seq_count+=1
  else:
    None
  
print(f'The number of sequnces the fasta file contains is {seq_count}')

#----------------------
#     Question 13    
#----------------------
from parse_fasta import read_fasta

# Read the FASTA file
genes = read_fasta("../../data/genes.fasta")

# Find the longest gene
longest_gene = max(genes, key=lambda gene: len(genes[gene]))

# Print its name and length
print("Longest gene:", longest_gene)
print("Length:", len(genes[longest_gene]))

#----------------------
#     Question 14    
#----------------------
#Using your `gc_content` function on the parsed `genes.fasta`, print every gene whose GC% is **above 52%**. (Expect `thrA` and `recA`.)

def gc_content(seq):
    seq = seq.upper()
    gc = seq.count("G") + seq.count("C")
    return (gc / len(seq)) * 100

# Read the FASTA file
genes = read_fasta("../../data/genes.fasta")

# Print genes with GC > 52%
for gene_name, sequence in genes.items():
    gc = gc_content(sequence)
    if gc > 52:
        print(f"{gene_name}: {gc:.2f}%")

#----------------------
#     Question 15    
#----------------------
from Bio import SeqIO
from Bio.SeqUtils import gc_fraction

for record in SeqIO.parse("../../data/genes.fasta", "fasta"):
    length = len(record.seq)
    gc = gc_fraction(record.seq) * 100
    print(record.id, length, f"{gc:.2f}%")

#----------------------
#     Question 16   
#----------------------
from Bio import SeqIO

count = 0

for record in SeqIO.parse("../../data/sample_reads.fastq", "fastq"):
    count += 1

print("Total reads:", count)

#----------------------
#     Question 17   
#----------------------
from Bio import SeqIO

passed = 0
failed = 0

for record in SeqIO.parse("../../data/sample_reads.fastq", "fastq"):
    qualities = record.letter_annotations["phred_quality"]
    mean_quality = sum(qualities) / len(qualities)

    if mean_quality >= 30:
        passed += 1
    else:
        failed += 1

print("Passed:", passed)
print("Failed:", failed)

#----------------------
#     Question 18
#----------------------
def transcribe(seq):
   return seq.replace("T", "U")

def translate_first_codon(seq):
    rna = transcribe(seq)
    return rna[:3]

sequence = "ATGCGT"

print(transcribe(sequence))
print(translate_first_codon(sequence))

#----------------------
#     Question 19
#----------------------
from Bio import SeqIO
from Bio.SeqUtils import gc_fraction

records = list(SeqIO.parse("../../data/genes.fasta", "fasta"))

highest_gc = max(records, key=lambda rec: gc_fraction(rec.seq))

print(highest_gc.id, gc_fraction(highest_gc.seq) * 100)

#----------------------
#     Question 20
#----------------------
from Bio import SeqIO

passed = 0

with open("passed_reads.txt", "w") as outfile:
    for record in SeqIO.parse("../../data/sample_reads.fastq", "fastq"):
        qualities = record.letter_annotations["phred_quality"]
        mean_quality = sum(qualities) / len(qualities)

        if mean_quality >= 30:
            outfile.write(record.id + "\n")
            passed += 1

print("Reads passed:", passed)