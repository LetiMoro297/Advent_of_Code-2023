File = open("Day4.txt","r") 
Data = read(File, String)
close(File)
Lines = split(Data, "\r\n")
n = length(Lines)
Numbers = [split(Lines[i], ":")  for i in 1:n]
Numbers = [split(Numbers[i][2], "|")  for i in 1:n]
Winning = [split(Numbers[i][1], " ")  for i in 1:n]
Extracted = [split(Numbers[i][2], " ")  for i in 1:n]

for i in 1:n
    Winning[i] = deleteat!(Winning[i], findall(x->x == "", Winning[i]))
    Extracted[i] = deleteat!(Extracted[i], findall(x->x == "", Extracted[i]))
end
w = length(Winning[1])
e = length(Extracted[1])

Winning = reshape([parse(Int, Winning[i][j]) for j in 1:w for i in 1:n], (n, w))
Extracted = reshape([parse(Int, Extracted[i][j]) for j in 1:e for i in 1:n], (n, e))

Total = 0
for i in 1:n
    cont = 0
    for j in 1:w
        if Winning[i, j] in Extracted[i, :]
            cont += 1
        end
    end 
    global Total += Int(round(2.0^(cont-1)))
end
println("Il totale dei punti fatti è $Total")

NumSc = ones(n,1)
for i in 1:n
    count = 0
    for j in 1:w
        if Winning[i, j] in Extracted[i, :]
            count += 1
        end
    end 
    for k in 1:count
        global NumSc[i+k] += 1*NumSc[i]
    end
end
println(NumSc[1:8])
println("Il numero totale di gratta e vinci è", sum(NumSc))
