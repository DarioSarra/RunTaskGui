using Revise
using Distributed
# add a process if there are less than 2
nprocs() != 3 && addprocs(2)
# add modules to all the processes
@everywhere using LibSerialPort
@everywhere using Dates
@everywhere using Interact
using Blink: Window,body!
@everywhere using DataFrames
@everywhere using CSV: read
@everywhere using StatsPlots
@everywhere using ShiftedArrays
@everywhere include(joinpath(@__DIR__, "task_struct.jl"))
@everywhere include(joinpath(@__DIR__, "running_task.jl"))
@everywhere include(joinpath(@__DIR__, "User_Interface.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","timer_observable.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","loading_task.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","streaks.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","pokes_plotting.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","notes.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","plotting_control.jl"))
####
test = define_task();
ui_test = control_task(test);
ui_test[:Plot][]
test[]
p1 = plot_routine(test[])
df = collect_task_data(test[])
s = streak_it(df)
##
p3= plot(bg = :white,
	framestyle = :none,
	size = (200, 500),
	legend = false
	)
p = plot()

function annotate_session!(plt,streaks::AbstractDataFrame)
	envs = union(s.Environment)
	env_message = "Environment:"*join(envs,",")

	rew_message = "Rewards: $(sum(s.Num_Rewards))"
	streak_message = "Streak: $(maximum(s.Streak))"
	block_message = "Block: $(maximum(s.Block))"
	messages = [env_message,rew_message,streak_message,block_message]
	series_ann = [Plots.text(m, 25, :black, :left) for m in messages]

	scatter!(p3,[1,1,1,1],[4,3,2,1],markersize = 0,series_annotations = series_ann)
end
