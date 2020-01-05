using Distributed
nprocs() < 2 && addprocs(1)

@everywhere using LibSerialPort
@everywhere using Dates

@everywhere include(joinpath(@__DIR__, "task_struct.jl"))
@everywhere include(joinpath(@__DIR__, "running_task.jl"))
@everywhere x = Flipping_Task(1, "bho", "evening", 11, 1, true, false, true)
# t = @spawnat 2 run_task(x)

# @spawnat 2 x.running = false
