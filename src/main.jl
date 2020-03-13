using Distributed
## add a process if there are less than 2
nprocs() < 2 && addprocs(1)
# add modules to all the processes
@everywhere using LibSerialPort
@everywhere using Dates

#function take the runing state of the box from process 2 
running(box) = @fetchfrom 2 boxesrunning[box]
#function change the runing state of the box from process 2
running!(box, val) = @fetchfrom 2 boxesrunning[box] = val


@everywhere include(joinpath(@__DIR__, "task_struct.jl"))
@everywhere include(joinpath(@__DIR__, "running_task.jl"))
@everywhere x = Flipping_Task(1, "yy", "evening", 11, 1, true, false, false)

running!(x.box, true)
t = @spawnat 2 run_task(x)

running!(x.box, false)
