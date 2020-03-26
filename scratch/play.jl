port = SerialPort(Box_dict[1])
file = "/home/beatriz/Documents/Julia/modules1/RunTaskGui/src/../raw_data/test.txt"

if !port.open
    open(port)
    set_speed(port,115200)
    println("Opening Port")
end

read_m(port,file)
send_m(port,"0",file)
read_m(port,file)
close(port)

function read_m(port,file)
    m = readuntil(port, '\n', 0.5)
    open(file, "a") do io
        print(io, m)
    end
    sleep(0.5)
    return(m)
end

function send_m(port,what,file)
    write(port,"<"*what*">")
    sleep(0.5)
end




m = readuntil(port, '\n', 0.5)
open(file, "a") do io
    print(io, m)
end

println("Wait")
sleep(2.5)
write(port,"<60>")
if bytesavailable(port) > 0
  m = readuntil(port, '\n', 0.5)
end
for spec in session_specs(FT)
    #write(port,"<"*spec*">")
    write(port,testo)
    sleep(0.5)
end
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
