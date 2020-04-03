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
@everywhere using Plots
@everywhere include(joinpath(@__DIR__, "task_struct.jl"))
@everywhere include(joinpath(@__DIR__, "running_task.jl"))
@everywhere include(joinpath(@__DIR__, "User_Interface.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","timer_observable.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","loading_task.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","pokes_plotting.jl"))
@everywhere include(joinpath(@__DIR__, "Plotting","plotting_control.jl"))
####
test = define_task();
ui_test = control_task(test);
ui_test[:Plot][]
test[]
df = read(test[].filename; skipto = 12, header= Task_header, types = Task_FileDict)
size(df,1) == 0
plt = plot(bg = :white,
    size = (800, 500),
    legend = false,
    ylabel = "Right ------------------------------------------- Left",
    xlabel = "Time(s)",
    ylims = (-1.15,1.15)
    )
plot_routine2(test[])
plt

plt
##
tim = Timer(3)
t = run_timer(tim)
function basic()
	b = button()
	plt = Observable(plot(rand(10)))
	tim = Timer(3)
    timer = run_timer(tim)
	Interact.@map! plt begin
		&tim.elapsed
		plot(rand(10))
	end
	wdg = Interact.Widget(OrderedDict(:P=>plt,:B=>b))
	@layout! wdg Widgets.div(vbox(:B,:P))
	body!(Window(),wdg)
end
basic();



data = collect_task_data(test[])
plt = Observable(plot(
    bg = :white,
    size = (800, 500),
    legend = false,
    ylabel = "Right ------------------------------------------- Left",
    xlabel = "Time(s)",
    ylims = (-1.15,1.15)
    ))
plt[]
plt[] = plot(rand(10));
map(eachrow(data)) do x
    poke_plot(x,plt[])
end
plt[]
####
lastpokeout = data[end,:PokeOut]/1000

filter(row -> row[:PokeIn]/1000 > lastpokeout-20, data)
data[:PokeIn] .< lastpokeout-30

##
plt_test = Observable(plot(rand(10)))
testwidget = Widget{:test}(OrderedDict(:Plot=>plt_test))
@layout! test
plt_test[] = plot(rand(10));
body!(Window(),testwidget)
plt_test[] = Timer((t) ->  plot(rand(10)),1; interval=1)
##
c = nothing
isnothing(c)
##
function safeprint(x)
    @async begin
        println(x)
        sleep(0.2)
    end
end
x = 1
while x == 1
    @async begin
        Timer((t) -> safeprint("running"), 1; interval=1)
    end
end
##
using Blink
using Interact

const run_toggle = toggle(label = "run") |> onchange

const timer = Observable(0.0)

function switch_timer(switch)
	if switch
	global t = @async while true
			sleep(1 / 20)
			timer[] += 1 / 20
		end
	return
	else
		@async Base.throwto(t, InterruptException())
	return
	end
end

on(switch_timer, run_toggle)

widget = vbox(hbox(run_toggle))

window = Window()
body!(window, widget)

timer[]
##

s1 = Dates.now()

s2 = Dates.now()

s2-s1
