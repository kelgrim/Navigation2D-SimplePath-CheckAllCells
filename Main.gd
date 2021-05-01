extends Node2D


onready var start_point: Position2D = $StartPoint
onready var navigation_node = $Navigation2D
onready var tile_map = $Navigation2D/TileMap
onready var dots_node = $Dots

var packed_dot = preload("res://Dot.tscn")

var grid_size = 16
var chunk_length = 8

func _process(delta):
	if (Input.is_action_just_pressed("left_click")):
		# Clean up any dots from the previous click
		clear_dots()
		
		# Get the position of the click so we create a path for it. 
		var click_position = get_global_mouse_position()
		var points = navigation_node.get_simple_path(start_point.global_position, click_position, false)
		
		# Draw a line to visually see what the path looks like
		var line = Line2D.new()
		line.width = 1
		for point in points:
			line.add_point(point)
		dots_node.add_child(line)
		
		# for each point we get all tilemap positions between that point and the next one
		for i in (points.size() - 1) :
			var current_grid_positions = get_tilemap_positions_between_points(points[i], points[i+1])
			# for each grid position found, we place a dot on the map
			for j in current_grid_positions.size():
				place_dot(current_grid_positions[j])
			

# This function is the meat of it
func get_tilemap_positions_between_points(global_pos_from: Vector2, global_pos_to: Vector2) -> Array:
	var result = []
	# First get the length of the line from point a to point b
	var length = global_pos_from.distance_to(global_pos_to)
	# Divide that length up into chunks. The longer the line, the more chunks. 
	var chunks: int = ceil(length / chunk_length)
	for i in (chunks + 1):
		# weight is the amount travelled between a and b. For example: 0.5 would be halfway between a and b
		var weight = float(i) / chunks
		var between_position = lerp(global_pos_from, global_pos_to, weight)
		var between_position_on_grid = tile_map.world_to_map(between_position)
		# Add the gridmap position to the result only if it wasn't there yet
		if (!result.has(between_position_on_grid)):
			result.append(between_position_on_grid)
		
	return result	
	
func clear_dots():
	var dot_instances = dots_node.get_children()
	for dot in dot_instances:
		dot.queue_free()
		
func place_dot(grid_position: Vector2):
		var dot = packed_dot.instance()
		var cell_type = tile_map.get_cell(grid_position.x, grid_position.y)
		match cell_type:
			-1:
				dot.modulate = Color.brown
			0:
				dot.modulate = Color.antiquewhite
			1: 
				dot.modulate = Color.black
			2: 
				dot.modulate = Color.steelblue
			3: 
				dot.modulate = Color.blue
			
		var target_position = tile_map.map_to_world(grid_position)
		dot.global_position = Vector2(target_position.x + grid_size / 2, target_position.y + grid_size / 2)
		dots_node.add_child(dot)
	
