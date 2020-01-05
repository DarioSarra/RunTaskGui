x = Flipping_Task(1, "bho", "evening", 11, 1, true, false, true)
x.filename
ser = LibSerialPort.open(Box_dict[x.box], 115200)
port = SerialPort(Box_dict[x.box])
port.open
open(port)
set_speed(port,115200)
port.open
close(port)
port.open
write(ser,session_specs(x))
LibSerialPort.close(ser)
###
if bytesavailable(ser) > 0
  m = readuntil(ser, '\n', 0.5)
  write_row(m,x.filename)
end

####
t = @spawnat 2 run_task(x)
fetch(t)
replace("manf\0\0", "\0" => "")

function routine(name, check)
    f = joinpath(pwd(), "test", name * ".txt")
    start = time()
    i = 1
    while check
        t = (time() - start) / 3
        if  t > i
            i = i + 1
            stream_file = open(f, "a")
            println(stream_file, string(t))
            close(stream_file)
        end
        if time() - start > 10
            check = false
        end
    end
end
##

const files = Channel{String}(4)
const status = Channel{Bool}(4)
put!(files,"a")
put!(files,"b")

function do_work()
    for j in files
        routine(j,true)
    end
end

for i in 1:4 # start 4 tasks to process requests in parallel
   @async do_work()
end


F[2] = false
routine("r",F[1])
this = Task(rout("h",F[1]))
schedule(this)
2+2
################
const jobs = Channel{Int}(32);

const results = Channel{Tuple}(32);

function do_work()
           for job_id in jobs
               exec_time = rand()
               sleep(exec_time)                # simulates elapsed time doing actual work
                                               # typically performed externally.
               put!(results, (job_id, exec_time))
           end
       end;

function make_jobs(n)
           for i in 1:n
               put!(jobs, i)
           end
       end;

n = 12;

@async make_jobs(n);

for i in 1:4 # start 4 tasks to process requests in parallel
   @async do_work()
end

@elapsed while n > 0 # print out results
   job_id, exec_time = take!(results)
   println("$job_id finished in $(round(exec_time; digits=2)) seconds")
   global n = n - 1
end
################
