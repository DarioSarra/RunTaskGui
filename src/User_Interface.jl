function define_task(;Rack=1)
    RackBoxes = Dict(1=>1:4,2=>5:8)
    MouseID = textbox()
    Daily_session = dropdown(["morning","evening"])
    Weight = spinbox(1:50,value = 20)
    BoxN  = spinbox(RackBoxes[Rack])
    Prwd1 = spinbox(0:100,value = 60)
    Prwd2 = spinbox(0:100,value = 60)
    Psw1 = spinbox(0:100,value = 30)
    Psw2 = spinbox(0:100,value = 30)
    Delta = spinbox(0:100,value = 0)
    Barrier = checkbox(value = true)
    Stimulation = checkbox(value = false)
    PokesTracking = checkbox(value = false)

    output = Interact.@map Flipping_Task(&MouseID,
        &Daily_session,
        &Weight,
        &BoxN,
        &Prwd1,
        &Psw1,
        &Prwd2,
        &Psw2,
        &Delta,
        &Barrier,
        &Stimulation,
        &PokesTracking
    )

    wdg = Widget{:Task_attributes}(
        OrderedDict(:MouseID => MouseID,
            :Daily_session => Daily_session,
            :Weight => Weight,
            :BoxN => BoxN,
            :Prwd1 => Prwd1,
            :Psw1 => Psw1,
            :Prwd2 => Prwd2,
            :Psw2 => Psw2,
            :Delta => Delta,
            :Barrier => Barrier,
            :Stimulation => Stimulation,
            :PokesTracking => PokesTracking),
            output = output)

    @layout! wdg Widgets.div(
        hbox(
            hskip(1em),
            vbox(
                hbox(vbox("Box Number",:BoxN),hskip(2em),vbox("Mouse ID",:MouseID)),
                vskip(1em),
                hbox(vbox("Daily Session",:Daily_session),hskip(1em),vbox("Weight",:Weight)),
                vskip(1em),
                hbox(vbox("Protocol 1",vbox("P Reward",:Prwd1,"P switch",:Psw1)),
                    hskip(1em),
                    vbox("Protocol 2",vbox("P Reward",:Prwd2,"P switch",:Psw2)),
                    hskip(1em),
                    vbox("Delta",:Delta)
                    ),
                vskip(1em),
                hbox(vbox("Barrier",:Barrier),
                    hskip(1em),
                    vbox("Stimulation",:Stimulation),
                    hskip(1em),
                    vbox("Pokes Tracking",:PokesTracking)
                    )
                )
            )
        )
    body!(Window(),wdg)
    return wdg
end;

function control_task(FT)
    Start = button(label = "Start")
    Stop = button(label = "Stop")
    Interact.@on begin
        &Start
        running!(FT.BoxN, true)
        t = @spawnat 2 run_task(FT)
    end
    Interact.@on begin
        &Stop
        running!(FT.BoxN, false)
    end
    wdg = Widget{:Control_task}(OrderedDict(
        :Start => Start,
        :Stop => Stop,
        :Task => FT
    ))
    @layout! wdg Widgets.div(
        vbox(
            hbox(:Start,hskip(1em),:Stop),
            describe_task(FT)
            )
        )
    body!(Window(),wdg)
    return wdg
end

##
function describe_task(FT)
    list = fieldnames(Flipping_Task)
    v = [[x,getfield(FT,x)] for x in list]
    TextColumn(v)
end

function TextColumn(FieldName::Symbol,FieldValue)
    FName = string(FieldName)*":"
    FValue = string(FieldValue)
    NameDiv = dom"div"(FName)(style("font-weight" => "bold"))
    ValDiv = dom"div"(FValue)
    unit =  container([NameDiv,ValDiv])(style("display" => "flex", "flex-direction"=>"row"))
    CSSUtil.pad(10px, unit)
    # return dom"div"(unit)(style("flex-direction"=>"column"))
end

function TextColumn(v::AbstractVector{Any})
    if length(v) == 2
        return TextColumn(v...)
    else
        println("Too many valuse in this field")
        return nothing
    end
end

function TextColumn(StringArray)
    v = TextColumn.(StringArray)
    vbox(v...)
end
