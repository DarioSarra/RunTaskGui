Box_dict = Dict(1=>"/dev/ttyACM0")

struct Flipping_Task
    mouseID::String
    day::String
    daily_session::String
    filename::String
    weight::Int64
    box::Int64
    Prwd1::Int64
    Prwd2::Int64
    Psw1::Int64
    Psw2::Int64
    delta::Int64
    barrier::Bool
    stimulation::Bool
    pokestracking::Bool
end

const default_dir = joinpath(@__DIR__, "..", "raw_data") ##filepath default and goes up one

function Flipping_Task(mouse::String,
    daily_session::String,
    weight::Int64,
    box::Int64,
    Prwd1::Int64,
    Prwd2::Int64,
    Psw1::Int64,
    Psw2::Int64,
    delta::Int64,
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
    daily_session,
    filename,
    weight,
    box,
    Prwd1,
    Prwd2,
    Psw1,
    Psw2,
    delta,
    barr,
    stim,
    p_trk)
end
