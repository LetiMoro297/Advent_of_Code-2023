function check_str(a)
    return tryparse(Float64, a) !== nothing
end

function near_coord(a, l, xMax, xMin, yMax, yMin)
    # a = (x,y) son le coordinate della prima cifra di un numero con l cifre, che si sviluppa in 
    # orizzontale (x = riga, y= colonna). Da fare attenzione se a è sul bordo
    (x, y) = a
    if x == xMin
        if y == yMin
            return append!([(x, y+l)], [(x+1, yi) for yi in yMin:yMin+l])
        elseif y+l-1 == yMax
            return append!([(x, y-1)], [(x+1, yi) for yi in y-1:yMax])
        else
            return append!([(x, y-1); (x, y+l)], [(x+1, yi) for yi in y-1:y+l])
        end
    elseif x == xMax
        if y == yMin
            return append!([(x, y+l)], [(x-1, yi) for yi in y:y+l])
        elseif y+l-1 == yMax
            return append!([(x, y-1)], [(x-1, yi) for yi in y-1:yMax])
        else
            return append!([(x, y-1); (x, y+l)], [(x-1, yi) for yi in y-1:y+l])
        end
    else
        if y == yMin
            return append!([(x, y+l)], [(x+1, yi) for yi in y:y+l], [(x-1, yi) for yi in y:y+l])
        elseif y+l-1 == yMax
            return append!([(x, y-1)], [(x+1, yi) for yi in y-1:yMax], [(x-1, yi) for yi in y-1:yMax])
        else
            return append!([(x, y+l), (x, y-1)], [(x+1, yi) for yi in y-1:y+l],
            [(x-1, yi) for yi in y-1:y+l])
        end
    end
end

File = open("Day3.txt","r") 
Data = read(File, String)
close(File)
Lines = split(Data, "\r\n")

s = length(Lines)
d = length(Lines[1])
Symb_list = []
Coord = Dict()
NumSym = []
CompleteNumbers = Dict()
for i in 1:s
    nopoints = replace(Lines[i], "." => "" )
    global NumSym = append!(NumSym, [nopoints])
    for j in 1:d
        ch = Lines[i][j]
        st = string(ch)
        if ch != '.'
            Coord[(i,j)] = ch
        end
        if check_str(st)
            continue
        elseif (ch != '.') & !(ch in Symb_list)
            global Symb_list = append!(Symb_list, [ch])
        end
    end
end

ValidCoord = Dict()
AshCoord = Dict()
for i in 1:s
    j = 1
    while j <= d
        l = 1
        if (i,j) in keys(Coord)
            ch = Coord[(i,j)]
            st = string(ch)
            if check_str(st)
                flag = true
                while flag & ((i, j+l) in keys(Coord))
                    ch2 = Coord[(i,j+l)]
                    st2 = string(ch2)
                    if check_str(st2)
                        l += 1
                    else
                        flag = false
                    end
                end
                ValidCoord[(i,j)] = near_coord((i,j), l, s, 1, d, 1)
                CompleteNumbers[(i, j)] = parse(Int, Lines[i][j:j+l-1])
            elseif st == "*"
                AshCoord[(i, j)] = near_coord((i, j), 1, s, 1, d, 1)
            end
        end
        j += l
    end
end

N = 0

for (i, j) in keys(ValidCoord)
    flag = false
    n = CompleteNumbers[(i, j)]
    for (x, y) in ValidCoord[(i, j)]
        if (x, y) in keys(Coord)
            if Coord[(x, y)] in Symb_list
                flag = true
                break
            end
        end
    end
    if flag
        N += n
    end
end

println("La somma dei numeri nel meccanismo è $N")

N = 0
println("INIZIO")
for (i, j) in keys(AshCoord)
    values = []
    count = 0
    flag = false
    for (x, y) in AshCoord[(i, j)]
        if (x, y) in keys(Coord)
            ch = Coord[(x, y)]
            st = string(ch)
            if check_str(st)
                flag = true
                flag2 = true
                l = 1
                while flag2
                    if (x, y-l) in keys(Coord)
                        ch2 = Coord[(x, y-l)]
                        st2 = string(ch2)
                        if check_str(st2)
                            l += 1
                        else 
                            flag2 = false
                        end
                    else 
                        flag2 = false
                    end
                end
                n = CompleteNumbers[(x, y-l+1)]
                if n in values
                    continue
                else 
                    count += 1
                    values = append!(values, n)
                end
            end
        end
    end
    if flag & (count >1)
        N += prod(values)
    end
    if count > 2
        println(i, " ", j)
    end
end

println("La somma (con prodotti *) dei numeri nel meccanismo è $N")

["105'050'475 è troppo alto", "105'035'994 non è", "80'205'464 non è"]