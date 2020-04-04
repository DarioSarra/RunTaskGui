function plot_routine(FT::Flipping_Task)
    p1 = plot(bg = :white,
      size = (700, 500),
      legend = false,
      ylabel = "Right ------------------- Left",
      xlabel = "Time(s)",
      ylims = (-1.15,1.15)
      )
    p2 = plot(bg = :white,
      size = (700, 500),
      ylabel = "Density",
      xlabel = "Pokes after last reward"
      )
    p3= plot(bg = :white,
      framestyle = :none,
      legend = false,
      size = (200, 500),
      )
    data = collect_task_data(FT)
    if isnothing(data)
      scatter!(p1,rand(10))
      plot!(p2,rand(10))
    else
      lastpokeout = data[end,:PokeOut]/1000
      pokedata = filter(row -> row[:PokeIn]/1000 > lastpokeout-20, data)
      map(eachrow(pokedata)) do x
        poke_plot!(p1,x)
      end
      streak = streak_it(data)
      density!(p2,streak.AfterLast,group = streak.Side)
      annotate_session!(p3,streak)
    end
    l = @layout [a ; b c]
    plt = plot(p1,p2,p3, layout = l,size = (700,700))
    return plt
end
