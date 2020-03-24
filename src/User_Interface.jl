Rack = 1
RackBoxes = Dict(1=>1:4,2=>1:5)
Box_n  = spinbox(RackBoxes[Rack])
MouseID = textbox()
Daily_session = dropdown(["morning","evening"])
Weight = spinbox(1:50,value = 20)
