Box_dict = Dict(1=>"/dev/ttyACM0")

struct Flipping_Task
    MouseID::String
    Day::String
    DailySession::String
    DailyFile::Char
    weight::Int64
    BoxN::Int64
    Prwd1::Int64
    Psw1::Int64
    Prwd2::Int64
    Psw2::Int64
    Delta::Int64
    Barrier::Bool
    Stimulation::Bool
    PokesTracking::Bool
    filename::String
end

const default_dir = joinpath(@__DIR__, "..", "raw_data") ##filepath default and goes up one

function Flipping_Task(mouse::String,
    DailySession::String,
    weight::Int64,
    BoxN::Int64,
    Prwd1::Int64,
    Psw1::Int64,
    Prwd2::Int64,
    Psw2::Int64,
    Delta::Int64,
    barr::Bool,
    stim::Bool,
    p_trk::Bool;
    dir = default_dir)

    d = replace(string(Dates.today()), "-"=>"")
    session =  mouse*"_"*d
    i = 97
    filename = joinpath(dir,session*Char(i)*".txt")
    while ispath(filename)
        i = i+1
        filename = joinpath(dir,session*Char(i)*".txt")
    end
    Flipping_Task(mouse,
    d,
    DailySession,
    Char(i),
    weight,
    BoxN,
    Prwd1,
    Psw1,
    Prwd2,
    Psw2,
    Delta,
    barr,
    stim,
    p_trk,
    filename)
end
