using StatsBase

#%% Read and organise data
File = open("Day7.txt","r") 
Data = read(File, String)
close(File)
Lines = split(Data, "\r\n")
Hands = Dict()
Mani = []
for (i, line) in enumerate(Lines)
    hand, bet = split(line, " ")
    global Mani = append!(Mani, [hand])
    if hand in keys(Hands)
        println("Attenzione: la giocata $hand si trovava già nel dizionario, è stata rimossa")
        println("La sua scommessa associata è $bet")
    else
        Hands[hand] = parse(Int, bet)
    end
end
#%%

function confronto(hand1, hand2)
    semi = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
    D1 = Dict()
    D2 = Dict()
    for i in semi
        D1[i] = 0
        D2[i] = 0
    end
    for i in 1:5
        s1 = string(hand1[i])
        s2 = string(hand2[i])
        D1[s1] += 1
        D2[s2] += 1
    end

    c1 = countmap(values(D1))
    c2 = countmap(values(D2))
    if 5 in keys(c1)
        if 5 in keys(c2)
            return confronto_semi(hand1, hand2)
        else
            return false
        end
    elseif 5 in keys(c2)
        return true
    elseif 4 in keys(c1)
        if 4 in keys(c2)
            return confronto_semi(hand1, hand2)
        else
            return false
        end
    elseif 4 in keys(c2)
        return true
    elseif 3 in keys(c1)
        if 3 in keys(c2)
            if 2 in keys(c1) 
                if 2 in keys(c2)
                    return confronto_semi(hand1, hand2)
                else 
                    return false
                end
            elseif 2 in keys(c2)
                return true
            else
                return confronto_semi(hand1, hand2)
            end
        else
            return false
        end
    elseif 3 in keys(c2)
        return true
    elseif 2 in keys(c1) # 1 ha almeno una coppia
        if c1[2]>1       # 1 ha due coppie
            if 2 in keys(c2)    #2 ha almeno una coppia
                if c2[2]>1      #2 ha due coppie
                    return confronto_semi(hand1, hand2)
                else            #2 ha una coppia
                    return false
                end
            end
        elseif 2 in keys(c2)   #1 ha una coppia, 2 ha almeno due coppie
            if c2[2]>1         #2 ha due coppie
                return true
            else                #2 ha una coppia
                return confronto_semi(hand1, hand2)
            end
        else 
            return false        #2 non ha coppie, 1 ne ha una
        end
    elseif 2 in keys(c2)
        return true
    else
        return confronto_semi(hand1, hand2)
    end
    return false
end
function confronto_semi(hand1, hand2)
    semi = "AKQJT98765432"
    i = 1
    while i<6
        c1 = hand1[i]
        c2 = hand2[i]
        if findfirst(c1, semi)[1] < findfirst(c2, semi)[1]
            return false
        elseif findfirst(c1, semi)[1] > findfirst(c2, semi)[1]
            return true
        end
        i += 1
    end
    if i == 6
        return false
    end
end

Final = sort(Mani, lt = confronto)
tot = 0
for (pos, hand) in enumerate(Final)
    global tot += pos*Hands[hand]
end

println("Il totale dei ranking moltiplicati per le scommesse è $tot")

#%% Part 2


function confronto2(hand1, hand2)
    semi = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
    jolly = "J"
    D1 = Dict()
    D2 = Dict()
    j1 = 0
    j2 = 0
    for i in semi
        D1[i] = 0
        D2[i] = 0
    end
    for i in 1:5
        s1 = string(hand1[i])
        s2 = string(hand2[i])
        if s1 == "J"
            j1 += 1
        else
            D1[s1] += 1
        end
        if s2 == "J"
            j2 += 1
        else         
            D2[s2] += 1
        end        
    end

    c1 = countmap(values(D1))
    c2 = countmap(values(D2))

    val1 = []
    val2 = []

    for i in keys(c1)
        for j in 1:c1[i]
            val1 = append!(val1, [i])
        end
    end
    for i in keys(c2)
        for j in 1:c2[i]
            val2 = append!(val2, [i])
        end
    end

    
    val1 = sort(val1, rev=true)
    val2 = sort(val2, rev=true)


    if val1[1] + j1 == val2[1] + j2
        if val1[2] == val2[2]
            return confronto_semi2(hand1, hand2) 
        elseif  val1[2] < val2[2]
            return true
        else 
            return false
        end
    elseif val1[1] + j1 > val2[1] + j2
       return false
    elseif val1[1] + j1 < val2[1] + j2
        return true
    end
    return false
end
function confronto_semi2(hand1, hand2)
    semi = "AKQT98765432J"
    i = 1
    while i<6
        c1 = hand1[i]
        c2 = hand2[i]
        if findfirst(c1, semi)[1] < findfirst(c2, semi)[1]
            return false
        elseif findfirst(c1, semi)[1] > findfirst(c2, semi)[1]
            return true
        end
        i += 1
    end
    if i == 6
        return false
    end
end

Final2 = sort(Mani, lt = confronto2)
tot2 = 0
for (pos, hand) in enumerate(Final2)
    tot2 += pos*Hands[hand]
end

println("Il totale dei ranking moltiplicati per le scommesse è diventato $tot2")
