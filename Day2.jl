File = open("Day2.txt","r") 
Data = read(File, String)
close(File)
Lines = split(Data, "\r\n")

RedMax = 12
GreenMax = 13
BlueMax = 14

#%% 
T = 0
S = 0
for (i, Line) in enumerate(Lines)
    games = split(Line, ":")[2]
    Games = split(games, ";")
    flag1 = true
    flag2 = true
    flag3 = true
    minR = 0
    minG = 0
    minB = 0
    for set in Games
        set = split(set, ",")
        for color in set
            if occursin("red", color)
                Num = color[2:end-4]
                flag1 = (parse(Int, Num) <= RedMax) & flag1
                minR = max(minR, parse(Int, Num))
            elseif occursin("green", color)
                Num = color[2:end-6]
                flag2 = (parse(Int, Num) <= GreenMax) & flag2
                minG = max(minG, parse(Int, Num))
            elseif occursin("blue", color)
                Num = color[2:end-5]
                flag3 = (parse(Int, Num) <= BlueMax) & flag3
                minB = max(minB, parse(Int, Num))
            end
        end
    end
    if flag1 & flag2 & flag3
       global T += i
    end
    global S += minR*minG*minB
end
println("Somma ID con giochi possibili = $T")
println("Somma prodotti # minimo di cubi per colore = $S")
#%%
