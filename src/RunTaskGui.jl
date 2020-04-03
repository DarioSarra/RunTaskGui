using Distributed
addprocs(1)

@everywhere using LibSerialPort
@everywhere using Dates

@everywhere include("task_struct.jl")
@everywhere include("running_task.jl")
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
