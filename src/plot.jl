function plot_network(g; vertexnames=1:nv(g), layalg=stressmajorize_layout)
    x, y = layalg(g)
    
    xs = Vector{Float64}()
    ys = Vector{Float64}()

    for e in edges(g)
        append!(xs, [x[src(e)], x[dst(e)], NaN])
        append!(ys, [y[src(e)], y[dst(e)], NaN])
    end
        
    es = scatter(x=xs, y=ys, mode="lines", showlegend=false, marker_color=:grey, line_width=.5)
    
    ns = scatter(
            x=x, y=y, mode="markers", marker_color="orange",
            marker_line_color="white", marker_line_width=1,
            text=vertexnames, hoverinfo="text")

    l = Layout(xaxis_visible=false, yaxis_visible=false, hovermode=:closest)

    return Plot([es, ns], l)
end
