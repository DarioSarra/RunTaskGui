mutable struct Clock
    running::Bool
    time::DateTime
end

function Clock()
    time = Dates.now()
    Clock(true,time)
end

function run_clock(c::Clock)
    if !c.running
        c.running = true
    end
    @async begin
        while c.running
            c.time = Dates.now()
            yield()
        end
        println("clock stopped")
    end
end

function stop_clock(c::Clock)
    c.running = false
end

mutable struct Timer
    clock::Clock
    interval::Millisecond
    elapsed::Observable{Int64}
end

function Timer(interval::Millisecond)
    clock = Clock()
    Timer(clock,interval,Observable(0))
end

function Timer(interval::Int64)
    convert = Millisecond(Second(interval))
    Timer(convert)
end

function Timer(interval::T) where {T <: Period}
    convert = Millisecond(Second(interval))
    Timer(convert)
end

function run_timer(timer::Timer)
    if !timer.clock.running
        timer.clock.running = true
    end
    start = timer.clock.time
    run_clock(timer.clock)
    @async begin
        while timer.clock.running
            new_elapsed = Int64(ceil((timer.clock.time-start)/timer.interval))
            if new_elapsed > timer.elapsed[]
                timer.elapsed[] =  new_elapsed
            end
            yield()
        end
    end
end
