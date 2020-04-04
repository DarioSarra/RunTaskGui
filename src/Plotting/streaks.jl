function streak_it(df::AbstractDataFrame)
    df[!,:Side] = [Bool(a) ? "L" : "R" for a in df.Side]
    df[!,:Streak] = count_sequence(df.Side)
    df[!,:Block] = count_sequence(df.Wall)
    df.Environment = string.(df.Prwd).*"/".*string.(df.Psw)
    streak_table = by(df, :Streak) do dd
        dt = DataFrame(
        Num_pokes = size(dd,1),
        Num_Rewards = length(findall(dd[!,:Reward].==1)),
        Last_Reward = findlast(dd[!,:Reward] .== 1).== nothing ? 0 : findlast(dd[!,:Reward] .== 1),
        Block = dd[1,:Block],
        Side = dd[1,:Side],
        Environment = dd[1,:Environment])
        return dt
    end
    streak_table[!,:AfterLast] = streak_table.Num_pokes .- streak_table.Last_Reward;
    return streak_table
end

"""
`count_sequence`
count when along an array the value of i+1 is different from i
"""
function count_sequence(series::AbstractArray)
    v_count = [1]
    count = 1
    for i = 2:size(series,1)
        if series[i] == series[i-1]
            count = count
        else
            count = count+1
        end
        push!(v_count,count)
    end
    return v_count
end
