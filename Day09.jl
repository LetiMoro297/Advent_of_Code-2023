#%% Load Data
File = open("Day9.txt","r") 
Data = read(File, String)
close(File)
Lines = split(Data, "\r\n")
Lines = deleteat!(Lines, findall(x->x == "", Lines)) 
Numbers = [split(Lines[i], " ") for i in eachindex(Lines)]
n = length(Numbers)
Sequences = [[parse(Int, Numbers[i][j]) for j in eachindex(Numbers[i])] for i in 1:n]

#%% Part 1
function toZeros(line)
    # Prende in input una sequenza e restituisce un vettore di vettori dove la prima riga è l'input,
    # la seconda è data dalle differenze due a due dei dati .... l'ultima son tutti 0
    flag = true
    i = 1
    Decomp = [line]
    newline = line
    while flag
        prec = newline
        N = length(prec)
        newline = [prec[i+1]-prec[i] for i in 1:N-1]
        Decomp = append!(Decomp, [newline])
        if newline == zeros(N-1)
            flag = false
        else
            i +=1
        end
    end
    return Decomp
end

function NewValue(Decomp)
    N = length(Decomp)
    nmin = length(Decomp[end])
    missingNumbers = N-nmin
    News = [[0 for i in 1:missingNumbers+1]]

    while missingNumbers > 0
        newline = [0 for i in missingNumbers]
        News = append!(News, [newline])
        missingNumbers += -1
    end
    return missingNumbers
end

v = vec([10 13 16 21 30 45])
Decomp = toZeros(v)
NewValue(Decomp)







for (i, line) in enumerate(Sequences)

end
