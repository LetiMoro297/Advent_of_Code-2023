#%% Load and read Data
File = open("Day10.txt","r") 
Data = read(File, String)
close(File)
Lines = split(Data, "\r\n")
Lines = deleteat!(Lines, findall(x->x == "", Lines)) 

#%% Part 1
StartCoord = (0,0)
nlines = length(Lines)
ncols = length(Lines[1])
flag = false

for i in 1:nlines
    if flag == true
        break 
    end
    for j in 1:nlines
        if Lines[i][j] == 'S'
            StartCoord = (i, j)
            flag = true
            break
        end
    end
end
StartCoord = (59, 52)

Steps = Dict()
Steps[0] = StartCoord
FirstStep = (0, 0)
LastStep = (0,0)
(x, y) = StartCoord
if Lines[x-1][y] in "F|7"
    FirstStep = (x-1, y)
    if Lines[x+1][y] in "J|L"
        LastStep = (x+1, y)
    elseif Lines[x][y-1] in "F-L"
        LastStep = (x, y-1)
    elseif Lines[x][y+1] in "J-7"
        LastStep = (x, y+1)
    end
elseif Lines[x+1][y] in "J|L"
    FirstStep = (x+1, y)
    if Lines[x-1][y] in "F|7"
        LastStep = (x-1, y)
    elseif Lines[x][y-1] in "F-L"
        LastStep = (x, y-1)
    elseif Lines[x][y+1] in "J-7"
        LastStep = (x, y+1)
    end
elseif Lines[x][y-1] in "F-L"
    FirstStep = (x, y-1)
    if Lines[x-1][y] in "F|7"
        LastStep = (x-1, y)
    elseif Lines[x+1][y] in "J|L"
        LastStep = (x+1, y)
    elseif Lines[x][y+1] in "J-7"
        LastStep = (x, y+1)
    end
elseif Lines[x][y+1] in "J-7"
    FirstStep = (x, y+1)
    if Lines[x-1][y] in "F|7"
        LastStep = (x-1, y)
    elseif Lines[x+1][y] in "J|L"
        LastStep = (x+1, y)
    elseif Lines[x][y-1] in "F-L"
        LastStep = (x, y-1)
    end
end
Nmax = nlines*ncols
Steps[1] = FirstStep
Steps[Nmax+1] = LastStep
function NextStep(start, prec)
    (x, y) = start
    CurrendSymb = string(Lines[x][y])
    (a, b) = prec
    if x-1 == a #arrivo da nord
        if CurrendSymb == "J" #vado ad ovest
            FirstStep = (x, y-1)
        elseif CurrendSymb == "L" #vado ad est
            FirstStep = (x, y+1)
        elseif CurrendSymb == "|" #vado a sud
            FirstStep = (x+1, y)
        end
    elseif x+1 == a #arrivo da sud
        if CurrendSymb == "F" #vado ad est
            FirstStep = (x, y+1)
        elseif CurrendSymb == "7" #vado ad ovest
            FirstStep = (x, y-1)
        elseif CurrendSymb == "|" #vado a nord
            FirstStep = (x-1, y)
        end
    elseif y-1 == b #vengo da ovest
        if CurrendSymb == "J" #vado a nord
            FirstStep = (x-1, y)
        elseif CurrendSymb == "-" #vado ad est
            FirstStep = (x, y+1)
        elseif CurrendSymb == "7" #vado a sud
            FirstStep = (x+1, y)
        end 
    elseif y+1 == b #vengo da est
        if CurrendSymb == "-" #vado ad ovest
            FirstStep = (x, y-1)
        elseif CurrendSymb == "L" #vado a nord
            FirstStep = (x-1, y)
        elseif CurrendSymb == "F" #vado a sud
            FirstStep = (x+1, y)
        end
    else
        println("Attenzione, qualcosa è andato storto nel punto ($x, $y)")
        FirstStep = false
    end
    return FirstStep
end

newStep = FirstStep
lastnewStep = StartCoord
behindStep = LastStep
lastbehindStep = StartCoord
lenAvanti = 2
lenIndietro = 2
while newStep != behindStep
    global newStep, lastnewStep
    global behindStep, lastbehindStep
    global lenAvanti, lenIndietro
    #println(newStep, " ", lastnewStep)
    #println(behindStep, "  ", lastbehindStep)
    newStep2 = NextStep(newStep, lastnewStep)
    lastnewStep = newStep
    newStep = newStep2
    Steps[lenAvanti] = newStep
    lenAvanti += 1
    if newStep == behindStep
        break
    else
        #println("nel ciclo if:", behindStep, " ", lastbehindStep)
        behindStep2 = NextStep(behindStep, lastbehindStep)
        lastbehindStep = behindStep
        behindStep = behindStep2
        Steps[Nmax+lenIndietro] = behindStep
        lenIndietro += 1
    end
end
lenAvanti += -1
lenIndietro += -1

println("Per andare da S al punto più lontano, che ha coordinate $newStep, ci vogliono 
$lenAvanti passi in avanti e $lenIndietro passi all'indietro")


#%% Part 2

Circ = []
for k in values(Steps)
    (i, j) = k
    global Circ
    Circ = append!(Circ, [k])
end

InnerCount = 0
In = false
OpenLine = "0"
PrintData = ""
for i in 1:nlines
    for j in 1:ncols
        global InnerCount, In, Lines
        if (i, j) in Circ
            #println(i, " ", j)
            Sym = string(Lines[i][j])
            PrintData = PrintData*Sym
            if (Sym == "F") || (Sym == "L")
                OpenLine = Sym
            elseif Sym == "7"
                if OpenLine == "F"
                    continue
                elseif OpenLine == "L"
                    In = !In
                end
            elseif Sym == "J"
                if OpenLine == "L"
                    continue
                elseif OpenLine == "F"
                    In = !In
                end
            elseif Sym == "|"
                In = !In
            end
        elseif In
            PrintData = PrintData*"1"
            InnerCount += 1
        else
            PrintData = PrintData*"."
        end
        if j == ncols
            PrintData = PrintData*"\n"
        end
    end
end

println("Il totale dei punti interni è $InnerCount")
