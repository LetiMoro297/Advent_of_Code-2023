# -*- coding: utf-8 -*-
"""
Created on Fri Dec  8 14:50:27 2023

@author: Letiz
"""

def ReadFile (filename):
    doc = open(filename, 'r', encoding = 'utf-8')
    txt = doc.read()
    testo = txt.split('\n')      
        
    return testo 

Ls = ReadFile('Day1_prove1.txt')
n = len(Ls)
Numbers = []
for i in range(n):
    word = Ls[i]
    l = len(word)
    numb = []
    for j in range(l):
        char = word[j]
        if char.isnumeric():
            numb = numb + [int(word[j])]
    Numbers = Numbers + [10*numb[0] + numb[-1]]
    
N = sum(Numbers)
print('La somma richiesta è', N)

Lett_numb = ['zero', 'one', 'two', 'three', 'four', 'five', 
             'six', 'seven', 'eight', 'nine']

Dict = {}
for i in range(10):
    Dict[Lett_numb[i]] = i


Numbers = []
for i in range(n):
    word = Ls[i]
    l = len(word)
    numb = []
    Ind = []
    WordNum = []
    wordDic = {}
    for k in Lett_numb:
        if k in word:
            ind = word.find(k)
            indr = word.rfind(k)
            if ind == indr:
                wordDic[ind] = k
                Ind = Ind + [ind]
            else:
                wordDic[ind] = k
                wordDic[indr] = k
                Ind = Ind + [ind, indr]
            WordNum = WordNum + [k]
    for j in range(l):
        word_cont = 0
        char = word[j]
        if j in Ind:
            numb = numb + [Dict[wordDic[j]]]
            word_cont += 1
        elif char.isnumeric():
            numb = numb + [int(word[j])]
    if i == 15:
        print(wordDic, numb)
        
    Numbers = Numbers + [10*numb[0] + numb[-1]]
    
N = sum(Numbers)
print('La somma corretta richiesta è', N)

