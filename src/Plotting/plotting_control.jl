function plot_routine(FT::Flipping_Task,plt)
  # plt = plot(bg = :white,
  #     size = (800, 500),
  #     legend = false,
  #     ylabel = "Right ------------------------------------------- Left",
  #     xlabel = "Time(s)",
  #     ylims = (-1.15,1.15)
  #     )
  @async begin
      while boxesrunning[FT.BoxN]
        data = collect_task_data(FT)
        if isnothing(data)
          plot!(rand(10),plt)
        else
          map(eachrow(data)) do x
              poke_plot!(x,plt)
          end
        end
        sleep(0.01)
      end
      return plt
  end
end

function plot_routine2(FT::Flipping_Task)
    plt = plot(bg = :white,
      size = (800, 500),
      legend = false,
      ylabel = "Right ------------------------------------------- Left",
      xlabel = "Time(s)",
      ylims = (-1.15,1.15)
      )
    data = collect_task_data(FT)
    if isnothing(data)
      plot!(plt,rand(10))
    else
      map(eachrow(data)) do x
        poke_plot!(plt,x)
      end
    end
    return plt
end
