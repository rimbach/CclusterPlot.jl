using Plots
# unicodeplots()
gr()

function rectangle_from_coords(xb,yb,xt,yt)
    [
        xb yb
        xt yb
        xt yt
        xb yt
        xb yb
    ]
end

function plot_box(cre,cim,width)
    xb = cre -width/2;
    xt = cre +width/2;
    yb = cim -width/2;
    yt = cim +width/2;
    [
        xb yb
        xt yb
        xt yt
        xb yt
        xb yb
    ]
end

some_rects=[
    rectangle_from_coords(1 ,1 ,4 ,4 )
    rectangle_from_coords(10,10,15,15)
    ]
other_rects=[
    rectangle_from_coords(1 ,10,5 ,15)
    rectangle_from_coords(10,1 ,15,5 )
    ]

Bi = plot_box(0, 0, 6 )
B1 = plot_box(0, 0, 1/2 )
B2 = plot_box(2, 2, 1/3 )

plot(Bi[:,1], Bi[:,2], color=:black, legend=:none, grid=:none)
plot!(B1[:,1], B1[:,2], color=:red, fill = (0, 0.3, :red))
plot!(B2[:,1], B2[:,2], color=:red)
