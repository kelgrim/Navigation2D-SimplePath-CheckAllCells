Little example of figuring out which tiles are moved upon when generating a simple_path from a Navigation2D node. 

How to use:
Click anwhere on the map with left mouse button. A line will appear and dots for each tile that is crossed. 

How it works:
I draw a virtual line between a point and the next point. 
I divide that line into more point and for each of those I check what their position is on the tilemap. I add that position to an array of points if it wasn't already added there.

Notes: 
- It doesn't work with get_simple_path optimize = true. 
This could probably be fixed, but I don't feel like putting more time into it. 
The last dot can be on a tile that isn't in the navigation map. (Click on the water to see an example) This can also probably be fixed. (Or worked around by ignoring that tiletype)
