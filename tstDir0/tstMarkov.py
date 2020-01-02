import random

model={'START': ['i', 'you'], 'i': ['like'], 'like': ['to'], 'to': ['eat'], 'you': ['eat'], 'eat': ['apples','oranges'],'END': ['apples','oranges']}
generated = []
while True:
    if not generated:
        words = model['START']
    elif generated[-1] in model['END']:
        break
    else:
        words = model[generated[-1]]
    toAp = random.choice(words)
    generated.append(toAp)
print(generated)