from collections import Counter
import math

def entropy(input_string):
    if not input_string:
        return 0.0
        
    total_len = len(input_string)
    counts = Counter(input_string)
    
    entropy = 0.0
    for count in counts.values():
        prob = count / total_len
        entropy -= prob * math.log2(prob)
        
    return entropy

# print(entropy("aaaaa"))
