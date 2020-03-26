const boxesrunning = falses(8)

function session_specs(FT::Flipping_Task)
    sp = [string(FT.BoxN),
    string(FT.Prwd1),
    string(FT.Psw1),
    string(FT.Prwd2),
    string(FT.Psw2),
    string(FT.Delta),
    string(Int64(FT.Barrier)),
    string(Int64(FT.Stimulation)),
    string(Int64(FT.PokesTracking))]
    join(string.('<',sp,'>'))
end

function run_task(FT::Flipping_Task)
    port = SerialPort(Box_dict[FT.BoxN])
    file = FT.filename

    if !port.open
        open(port)
        set_speed(port,115200)
        println("Opening Port")
    end

    println("Wait")
    sleep(0.5)
    read_m(port,file)
    sleep(0.5)
    write(port,session_specs(FT))
    sleep(1)

    # for spec in session_specs(FT)
    #     send_m(port,spec,file)
    #     read_m(port,file)
    # end

    @async begin
        while boxesrunning[FT.BoxN]
          if bytesavailable(port) > 0
            m = readuntil(port, '\n', 0.5)
             if occursin("-666",m)
                 println("All is well in $(FT.BoxN)")
             end
            open(FT.filename, "a") do io
                print(io, m)
            end
          end
          sleep(0.001)
        end
        close(port)
        println("Box $(FT.BoxN) port closed")
    end
end

function read_m(port,file)
    m = readuntil(port, '\n', 0.5)
    open(file, "a") do io
        print(io, m)
    end
    sleep(1)
    return(m)
end

function send_m(port,what,file)
    write(port,"<"*what*">")
    sleep(1)
end
