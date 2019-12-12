Box_dict = Dict(1=>"/dev/ttyACM0")

struct Flipping_Task
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

function Flipping_Task(box::Int64,mouse::String,daily_session::String,weight::Int64,prot::Int64,barr::Bool,stim::Bool, p_trk::Bool; dir = pwd(), run = true)
    d = replace(string(Dates.today()), "-"=>"")
    session =  mouse*"_"*d
    i = 97
    filename = joinpath(dir,"raw_data",session*Char(i)*".txt")
    while ispath(filename)
        i = i+1
        filename = joinpath(dir,"raw_data",session*Char(i)*".txt")
    end
    Flipping_Task(box,mouse,d,daily_session,filename,weight,prot,barr,stim,p_trk,run)
end

function session_specs(FT::Flipping_Task)
    string(string(FT.box),string(FT.protocol),string(Int64(FT.barrier)),string(Int64(FT.stimulation),string(Int64(FT.pokestracking))))
end

function write_row(m,f)
    stream_file = open(f,"a")
    #println(stream_file,m)
    print(stream_file,m)
    close(stream_file)
    end
end

function run_task(FT::Flipping_Task)
    ser = LibSerialPort.open(Box_dict[FT.box], 115200)
    write(ser,session_specs(FT))
    start = time()
    while time() - start < 20
      if bytesavailable(ser) > 0
        m = readuntil(s, '\n', 0.1)
        # f_m = replace(m,"\0"=>"")
        write_row(m,FT.filename)
      end
    end
end
