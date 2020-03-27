function define_task(;Rack=1)
    Prepare = button("Prepare task")
    RackBoxes = Dict(1=>1:4,2=>5:8)
    MouseID = textbox()
    Daily_session = dropdown(["morning","evening"])
    Weight = spinbox(1:50,value = 20)
    BoxN  = spinbox(RackBoxes[Rack])
    Prwd1 = spinbox(0:100,value = 60)
    Psw1 = spinbox(0:100,value = 30)

    Alt_Prwd2 = spinbox(0:100,value = 60)
    Alt_Psw2 = spinbox(0:100,value = 30)
    Alt_Delta = spinbox(0:100,value = 0)
    c = hbox(vbox("Protocol 2",vbox("P Reward",Alt_Prwd2,"P switch",Alt_Psw2)),
        hskip(1em),
        vbox(vskip(2em),"Delta",Alt_Delta))
    t = togglecontent(c);

    Prwd2 = Interact.@map !&t ? &Prwd1 : &Alt_Prwd2
    Psw2 = Interact.@map !&t ? &Psw1 : &Alt_Psw2
    Delta = Interact.@map !&t ? 0 : &Alt_Delta

    Barrier = checkbox(value = true)
    Stimulation = checkbox(value = false)
    PokesTracking = checkbox(value = false)
    output = Observable{Flipping_Task}(Flipping_Task(missing))

    Interact.@map! output begin
        &Prepare
        Flipping_Task(&MouseID,
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
    end

    wdg = Widget{:Task_attributes}(
        OrderedDict(:Prepare => Prepare,
            :MouseID => MouseID,
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
                    #vbox("Protocol 2",vbox("P Reward",:Prwd2,"P switch",:Psw2)),
                    t
                    ),
                vskip(1em),
                hbox(vbox("Barrier",:Barrier),
                    hskip(1em),
                    vbox("Stimulation",:Stimulation),
                    hskip(1em),
                    vbox("Pokes Tracking",:PokesTracking)
                    )
                ),
                hskip(1em),
                :Prepare
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
