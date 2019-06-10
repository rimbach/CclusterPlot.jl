#
#  Copyright (C) 2018 Remi Imbach
#
#  This file is part of Ccluster.
#
#  Ccluster is free software: you can redistribute it and/or modify it under
#  the terms of the GNU Lesser General Public License (LGPL) as published
#  by the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.  See <http://www.gnu.org/licenses/>.
#

# @pyimport matplotlib.patches as patch

CC = ComplexField(53)
RR = RealField(53)

function drawBox(b::Array{fmpq,1}, color::String, opacity::Float64)
    shift = fmpq(1,2)*b[3]
    width = b[3]
    left  = b[1] - shift
    low   = b[2] - shift
    
    shift = convert(Float64, RR(shift))
    left  = convert(Float64, RR(left ))
    low   = convert(Float64, RR(low  ))
    width = convert(Float64, RR(width))
    
    if color=="no-fill"
        return matplotlib_patches.Rectangle( 
                               (left, low), 
                                width, width, 
                                fill=false, edgecolor="black",lw=2
                              )
    else
        return matplotlib_patches.Rectangle( 
                               (left, low ), 
                                width, width, 
                                facecolor=color, edgecolor="black", alpha=opacity 
                              )
    end
end

function drawBox(b::box, color::String, opacity::Float64)
    return drawBox([getCenterRe(b), getCenterIm(b), getWidth(b)], color, opacity)
end

function drawBox(b::box, fill, color::String, opacity::Float64)
    shift = fmpq(1,2)*getWidth(b)
    width = getWidth(b)
    left  = getCenterRe(b) - shift
    low   = getCenterIm(b) - shift
    
    shift = convert(Float64, RR(shift))
    left  = convert(Float64, RR(left ))
    low   = convert(Float64, RR(low  ))
    width = convert(Float64, RR(width))
    
    if fill==false
#         return matplotlib_patches[:Rectangle]( 
#                                (left, low), 
#                                 width, width, 
#                                 fill=false, edgecolor=color, lw=0.5
#                               )
        return matplotlib_patches.Rectangle( 
                               (left, low), 
                                width, width, 
                                fill=false, edgecolor=color, lw=0.5
                              )
    else
#         return matplotlib_patches[:Rectangle]( 
#                                (left, low ), 
#                                 width, width, 
#                                 facecolor=color, edgecolor="black", alpha=opacity
#                               )
        return matplotlib_patches.Rectangle( 
                               (left, low ), 
                                width, width, 
                                facecolor=color, edgecolor="black", alpha=opacity
                              )
    end
end

function drawDisk(d::Array{fmpq,1}, color::String, opacity::Float64)
    
    radius = convert(Float64, RR(d[3]))
    cRe    = convert(Float64, RR(d[1]))
    cIm    = convert(Float64, RR(d[2]))
    
    if color=="no-fill"
#         return matplotlib_patches[:Circle]( 
#                                (cRe, cIm), 
#                                 radius, 
#                                 fill=false, edgecolor="black"
#                               )
        return matplotlib_patches.Circle( 
                               (cRe, cIm), 
                                radius, 
                                fill=false, edgecolor="black"
                              )
    else
#         return matplotlib_patches[:Circle]( 
#                                (cRe, cIm), 
#                                 radius, 
#                                 facecolor=color, edgecolor="black", alpha=opacity 
#                               )
        return matplotlib_patches.Circle( 
                               (cRe, cIm), 
                                radius, 
                                facecolor=color, edgecolor="black", alpha=opacity 
                              )
    end
end
    
function plotCcluster( disks, initBox::Array{fmpq,1}; focus=false, markers=true )
    objects = []
    
    push!(objects, drawBox(initBox,     String("no-fill"), 0.0))
    enlargedBox = [ initBox[1], initBox[2], fmpq(5,4)*initBox[3] ]
    push!(objects, drawBox(enlargedBox, String("no-fill"), 0.0))
    
    for index = 1:length(disks)
        boxestemp = drawDisk( disks[index][2], "green", 0.5 )
        push!(objects, boxestemp)
    end
    
    fig, ax = subplots()
    
    left  = initBox[1] - initBox[3]; 
    right = initBox[1] + initBox[3]; 
    lower = initBox[2] - initBox[3]; 
    upper = initBox[2] + initBox[3];
        
    if focus && length(disks)>=1
         left  = disks[1][2][1] - disks[1][2][3]
         right = disks[1][2][1] + disks[1][2][3]
         lower = disks[1][2][2] - disks[1][2][3]
         upper = disks[1][2][2] + disks[1][2][3]
         for index = 2:length(disks)
            if (disks[index][2][1] - disks[index][2][3]) < left
                left  = disks[index][2][1] - disks[index][2][3]
            end
            if (disks[index][2][1] + disks[index][2][3]) > right
                right  = disks[index][2][1] + disks[index][2][3]
            end
            if (disks[index][2][2] - disks[index][2][3]) < lower
                lower  = disks[index][2][2] - disks[index][2][3]
            end
            if (disks[index][2][2] + disks[index][2][3]) > upper
                upper  = disks[index][2][2] + disks[index][2][3]
            end
         end
    end
    
    left = convert(Float64, RR(left))
    right = convert(Float64, RR(right))
    lower = convert(Float64, RR(lower))
    upper = convert(Float64, RR(upper))
    

    inflate = 0.05
    
#     ax[:set_xlim](left - inflate*(right-left), right + inflate*(right-left))
#     ax[:set_ylim](lower - inflate*(upper-lower), upper + inflate*(upper-lower))
    ax.set_xlim(left - inflate*(right-left), right + inflate*(right-left))
    ax.set_ylim(lower - inflate*(upper-lower), upper + inflate*(upper-lower))
    for index = 1:length(objects)
#         ax[:add_patch](objects[index])
        ax.add_patch(objects[index])
    end
    
    if markers
        for index = 1:length(disks)
            #draw markers at centers of disks
            center = CC( disks[index][2][1], disks[index][2][2] )
    #         ax[:plot]( convert(Float64, real(center)),
    #                    convert(Float64, imag(center)) , marker="1", markersize=6, color = "green")
            ax.plot( convert(Float64, real(center)),
                    convert(Float64, imag(center)) , marker="1", markersize=6, color = "green")
        end
    end
    
end

function plotCcluster_subdiv( CCs, discardedBoxes, initBox, focus=false )
    objects = []
    
    push!(objects, drawBox(initBox,     String("no-fill"), 0.0))
#     enlargedBox = [ initBox[1], initBox[2], fmpq(5,4)*initBox[3] ]
#     push!(objects, drawBox(enlargedBox, String("no-fill"), 0.0))
    
    for index = 1:length(discardedBoxes)
        boxestemp = drawBox( discardedBoxes[index], false, "red", 1.0 )
        push!(objects, boxestemp)
    end
    
    for index = 1:length(CCs)
        tempBO = getComponentBox(CCs[index],box(initBox[1],initBox[2],initBox[3]))
        boxestemp = drawBox( tempBO, true, "green", 0.3 )
        push!(objects, boxestemp)
        while !isEmpty(CCs[index])
            tempBO = pop(CCs[index])
            boxestemp = drawBox( tempBO, true, "green", 1.0 )
            push!(objects, boxestemp)
        end
        
    end
    
    fig, ax = subplots()
    
    left  = initBox[1] - initBox[3]; 
    right = initBox[1] + initBox[3]; 
    lower = initBox[2] - initBox[3]; 
    upper = initBox[2] + initBox[3];
        
    if focus && length(disks)>=1
         left  = disks[1][2][1] - disks[1][2][3]
         right = disks[1][2][1] + disks[1][2][3]
         lower = disks[1][2][2] - disks[1][2][3]
         upper = disks[1][2][2] + disks[1][2][3]
         for index = 2:length(disks)
            if (disks[index][2][1] - disks[index][2][3]) < left
                left  = disks[index][2][1] - disks[index][2][3]
            end
            if (disks[index][2][1] + disks[index][2][3]) > right
                right  = disks[index][2][1] + disks[index][2][3]
            end
            if (disks[index][2][2] - disks[index][2][3]) < lower
                lower  = disks[index][2][2] - disks[index][2][3]
            end
            if (disks[index][2][2] + disks[index][2][3]) > upper
                upper  = disks[index][2][2] + disks[index][2][3]
            end
         end
    end
    
    left  = left.num/left.den
    right = right.num/right.den
    lower = lower.num/lower.den
    upper = upper.num/upper.den

#     ax[:set_xlim](left, right )
#     ax[:set_ylim](lower, upper)
    ax.set_xlim(left, right )
    ax.set_ylim(lower, upper)
    for index = 1:length(objects)
#         ax[:add_patch](objects[index])
        ax.add_patch(objects[index])
    end
end
