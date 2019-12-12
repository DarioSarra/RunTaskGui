using LibSerialPort
using Dates

include("task_struct.jl")
###
list_ports()
port = "/dev/ttyACM0"
s = LibSerialPort.open(port, 115200)
write(s,"12100")
##
start = time()
while time() - start < 10
  if bytesavailable(s) > 0
    m = LibSerialPort.readline(s)
    println(m)
  end
end
##
LibSerialPort.readuntil(s,'x',5)
LibSerialPort.readline(s)
read(s,Char)

serial_loop(s)
LibSerialPort.close(s)
ret = readline(s, 1.0)

# while (Choice == -1) { Choice = Serial.read();}
# while (Box == -1) { Box = Serial.read();}
# while (SessionBarr == -1) {SessionBarr = Serial.read();}
# while (SessionStim == -1) {SessionStim = Serial.read();}
# while (TrackPokes == -1) {TrackPokes = Serial.read();}

write(s, "input\n")
