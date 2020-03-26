using Distributed
# add a process if there are less than 2
nprocs() != 3 && addprocs(2)
# add modules to all the processes
@everywhere using LibSerialPort
@everywhere using Dates
@everywhere using Interact
using Blink: Window,body!

#function take the runing state of the BoxN from process 2
running(BoxN) = @fetchfrom 2 boxesrunning[BoxN]
#function change the runing state of the BoxN from process 2
running!(BoxN, val) = @fetchfrom 2 boxesrunning[BoxN] = val
@everywhere include(joinpath(@__DIR__, "task_struct.jl"))
@everywhere include(joinpath(@__DIR__, "running_task.jl"))
@everywhere include(joinpath(@__DIR__, "User_Interface.jl"))
##
@everywhere x = Flipping_Task("micio", "evening", 11, 1, 60,30,60,30,1, true, false, false)
x
running!(x.BoxN, true)
t = @spawnat 2 run_task(x)
running!(x.BoxN, false)
###
y = define_task();
x = y[]
session_specs(x)
describe_task(x)
control_task(x);
