const Task_header = ["Reward","Side","HighSide","Protocol","Stim","StimFreq","Wall","PokeIn","PokeOut","Prwd","Psw","Delta","Box"]
const Task_FileDict = Dict("Reward"=> Bool,
    "Side" => Int64,
    "HighSide" => Int64,
    "Protocol" => Int64,
    "Stim" => Bool,
    "StimFreq" => Int64,
    "Wall" => Bool,
    "PokeIn" => Int64,
    "PokeOut" => Int64,
    "Prwd" => Int64,
    "Psw" => Int64,
    "Delta" => Int64,
    "Box" => Int64)

function collect_task_data(FT::Flipping_Task)
    if isfile(FT.filename)
        df = read(FT.filename; skipto = 12, header= Task_header, types = Task_FileDict)
        if size(df,1) > 0
            lastpokeout = df[end,:PokeOut]/1000
            return filter(row -> row[:PokeIn]/1000 > lastpokeout-20, df)
        else
            return nothing
        end
    else
        return nothing
    end
end
