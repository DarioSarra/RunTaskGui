
function session_specs(FT::Flipping_Task)
    [string(FT.box),string(FT.protocol),string(Int64(FT.barrier)),string(Int64(FT.stimulation),string(Int64(FT.pokestracking)))]
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
        @async begin
            while FT.running
              if bytesavailable(port) > 0
                m = readuntil(port, '\n', 0.5)
                 if occursin("-666",m)
                     println("All is well in $(FT.box)")
                 end
                open(FT.filename, "a") do io
                    print(io, m)
                end
              end
              sleep(0.001)
            end
            close(port)
            println("Box $(FT.box) port closed")
        end
    else
        println("This session was already run")
    end
end
