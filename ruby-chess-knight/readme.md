Knight travails - odin project
This program finds the shortest path that a knight chess piece can take when going from two chosen squares. 

This accepts two arrays of ([x, y]), start and end, between 0-7.

This does a breadth-first search starting from the first array coordinates and determines shortest path by
recording distance of each possible move from the source.

The possible moves of each square is stored in an adjacent list style graph.

This program most likely uses excessive amounts of space due to inefficiently storing information about every space. :(
