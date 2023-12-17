#%% Make Data
File = open("Day6.txt","r") 
Data = read(File, String)
close(File)
Lines = split(Data, "\r\n")
_, spacedtimes = split(Lines[1], ":")
_, spaceddistances = split(Lines[2], ":")
times =  split(spacedtimes, " ")
distances = split(spaceddistances, " ")
times = deleteat!(times, findall(x->x == "", times)) 
distances = deleteat!(distances, findall(x->x == "", distances)) 
Times = [parse(Int, k) for k in times]
Distances = [parse(Int, k) for k in distances]

#%%
function glue(Ls)
    Limit = 0
    l = 0
    L = length(Ls)
    for i in L:-1:1
        x = Ls[i]
        Limit += x*10^(l)
        l += length(string(x))
    end
    return Limit
end

Cont = [0 for k in Times]
for (i, LimiTime) in enumerate(Times)
    goal = Distances[i]
    for speed in 0:LimiTime
        mov_t = LimiTime - speed
        if mov_t*speed >= goal
            Cont[i] += 1
        end
    end
end
total = prod(Cont)
println("I prodotti dei casi di vittoria sono $total")

Limit_Time = glue(Times)
Limit_Distance = glue(Distances)
@time begin
    total = 0
    for speed in 0:Limit_Time
        mov_t = Limit_Time - speed
        if mov_t*speed >= Limit_Distance
            total += 1
        end
    end
end
println("I casi di vittoria nel secondo caso sono $total")

#%% In alternativa

@time begin
    Start_goodTimes = 0
    for speed in 0:Limit_Time
        mov_t = Limit_Time - speed
        if mov_t*speed >= Limit_Distance
            Start_goodTimes = speed
            break
        end
    end

    End_goodTimes = 0
    for speed in Limit_Time:-1:0
        mov_t = Limit_Time - speed
        if mov_t*speed >= Limit_Distance
            End_goodTimes = speed
            break
        end
    end

    total2 = End_goodTimes-Start_goodTimes+1
end

println("I due metodi sono uguali? ",total==total2)
