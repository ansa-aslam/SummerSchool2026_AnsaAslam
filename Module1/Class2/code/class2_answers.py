#----------------------
#     Question 1    
#----------------------
gene = "recA"
length = 1500
gc = 52.47

print(f'{gene} is {length}bp with {gc}% GC')

#----------------------
#     Question 2  
#----------------------
print(f'Type of variable "gene" is {type(gene)}')
print(f'Type of variable "length" is {type(length)}')
print(f'Type of variable "gc" is {type(gc)}')

#----------------------
#     Question 3    
#----------------------
def codon(seq_len):
  if seq_len % 3 == 0:
    print(f'the given sequence is a codon')
  else:
    print(f'the given sequence is not a codon')


#----------------------
#     Question 4    
#----------------------
seq = "ATGCGT"
len_of_seq = len(seq)


print(f'The length of sequence is {len_of_seq}')
print(f'The sequence when reversed will be written as {seq[::-1]}')
print(f'The first three bases (slice) of the given sequence are {seq[0:3]}')
