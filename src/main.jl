using Distributed
## add a process if there are less than 2
nprocs() != 3 && addprocs(2)
# add modules to all the processes
@everywhere using LibSerialPort
@everywhere using Dates
@everywhere using Interact

#function take the runing state of the box from process 2
running(box) = @fetchfrom 2 boxesrunning[box]
#function change the runing state of the box from process 2
running!(box, val) = @fetchfrom 2 boxesrunning[box] = val


@everywhere include(joinpath(@__DIR__, "task_struct.jl"))
@everywhere include(joinpath(@__DIR__, "running_task.jl"))
@everywhere x = Flipping_Task("xx", "evening", 11, 1, 60,60,30,30,1, true, false, false)


running!(x.box, true)
t = @spawnat 2 run_task(x)

running!(x.box, false)
