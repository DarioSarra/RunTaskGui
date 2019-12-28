
function session_specs(FT::Flipping_Task)
    [string(FT.box),string(FT.protocol),string(Int64(FT.barrier)),string(Int64(FT.stimulation),string(Int64(FT.pokestracking)))]
end

function write_row(m,f)
    stream_file = open(f,"a")
    #println(stream_file,m)
    print(stream_file,m)
    close(stream_file)
end

function run_task(FT::Flipping_Task)
    if FT.running
        port = SerialPort(Box_dict[x.box])
        if !port.open
            open(port)
            set_speed(port,115200)
            println("Opening Port")
        end

        println("Wait")
        sleep(2.5)
        for spec in session_specs(FT)
            write(port,spec)
            sleep(0.5)
        end
        start = time()
        @async begin
            while FT.running
              if bytesavailable(port) > 0
                m = readuntil(port, '\n', 0.5)
                 if occursin("-666",m)
                     println("All is well in $(FT.box)")
                 end
                write_row(m,FT.filename)
              end
              if time() - start > 20 #to change in while FT.running
                  FT.running = false
              end
            end
            close(port)
            println("Box $(FT.box) port closed")
        end
    else
        println("This session was already run")
    end
end
