Box_dict = Dict(1=>"/dev/ttyACM0")

mutable struct Flipping_Task
    box::Int64
    mouseID::String
    day::String
    daily_session::String
    filename::String
    weight::Int64
    protocol::Int64
    barrier::Bool
    stimulation::Bool
    pokestracking::Bool
    running::Bool
end

const default_dir = joinpath(@__DIR__, "..", "raw_data") ##filepath default and goes up one

function Flipping_Task(box::Int64,mouse::String,daily_session::String,weight::Int64,prot::Int64,barr::Bool,stim::Bool, p_trk::Bool;
    dir = default_dir, run = true)

    d = replace(string(Dates.today()), "-"=>"")
    session =  mouse*"_"*d
    i = 97
    filename = joinpath(dir,session*Char(i)*".txt")
    while ispath(filename)
        i = i+1
        filename = joinpath(dir,session*Char(i)*".txt")
    end
    Flipping_Task(box,mouse,d,daily_session,filename,weight,prot,barr,stim,p_trk,run)
end
