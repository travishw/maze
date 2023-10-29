extends TileMap

signal done

var start_x = (global.width/2)
var start_y= ((global.height/2) - 1)
var generation_complete = false
var rdf_stack = []
var steps = []

@onready var tile_map = $"."


func _unhandled_input(_event):
	#generates new maze when "space is pressed"pressed
	if Input.is_action_just_released("space"):
		generation_complete = false
		steps = []
		_ready()
	#toggles whether or not 2D map is visible on screen
	if Input.is_action_pressed("toggle_maze"):
		tile_map.show()
	if Input.is_action_just_released("toggle_maze"):
		tile_map.hide()
		
		
func _ready():
	#makes width and height odd
	if global.width % 2 == 0:
		global.width -= 1
	if global.height % 2 == 0:
		global.height -= 1
		
	#scales maze to make the maze fit properly on the window 
	var x_scale = 1152/(global.width*32.0)
	var y_scale = 1152/(global.height*32.0)
	scale = Vector2(x_scale, y_scale)
	
	#sets up grid for maze generation
	for i in range(global.width):
		for j in range(global.height):
			
			if i == 0 or j == 0 or i == global.width-1 or j == global.height-1:
				set_cell(0, Vector2i(i,j), 0, Vector2i(8,0))
			# regular wall
			elif i%2 == 0 or j%2 == 0:
				set_cell(0, Vector2i(i,j), 0, Vector2i(8,0))
			# floor
			else:
				set_cell(0, Vector2i(i,j), 0, Vector2i(4,0))
	#ensures random operations are random
	randomize()
	
	#sets start point to centre of maze
	set_cell(0, Vector2i(start_x,start_y), 0, Vector2i(6,0))

	
	rdf_init()
	
	#loops until maze is generated
	while not generation_complete:
		rdf_step()
	


func rdf_init():
	#looks at adjacent cells
	var offsets = [[1,0], [-1, 0], [0, 1], [0, -1]]
	#checks to see which cell is the starting cell
	for o in offsets:
		if get_cell_atlas_coords(0, Vector2i(start_x + o[0], start_y + o[1])) == get_cell_atlas_coords(0, Vector2i(0,-1)):
			rdf_stack.push_back(Vector2(start_x + o[0], start_y + o[1]))
		set_cell(0,  rdf_stack[0], 0, Vector2i(2, 0))
		
		
func rdf_step():
	#when generation is complete, clears the current stack and runs the to_3d function
	if len(rdf_stack) <= 0:
		generation_complete = true
		to_3d()
		return
	
	var curr = rdf_stack.pop_back()
	var next
	var found = false
	
	#looks at neighboring cells in random order
	var check_order = [[2,0], [-2, 0], [0, 2], [0, -2]]
	check_order.shuffle()
	for val in check_order:
		#checks to see if neighbor is an eligible tile 
		#and if so exits the loop
		next = Vector2(val[0], val[1])
		if get_cell_atlas_coords(0, Vector2i(curr + next)) == get_cell_atlas_coords(0, Vector2i(0,-1)):
			found = true
			break
	#when an eligible tile is found it will move to that tile and 
	#mark the tile it was just on as part of the path
	if found:
		rdf_stack.push_back(curr)
		set_cell(0, curr + (next/2), 0, Vector2i(6, 0))
		set_cell(0, curr + next, 0, Vector2i(2, 0))
		set_cell(0, curr, 0, Vector2i(6, 0))
		rdf_stack.push_back(curr+next)
	#if no tile is eligible it will backtrack until an eligible tile is found 
	#and mark any tiles it crosses as it backtracks as done so it will not move 
	#to those tiles again
	else:
		set_cell(0, curr, 0, Vector2i(0, 0))
		for dir in [[1,0], [0,1], [-1,0], [0,-1]]:
			var dir_vec = Vector2(dir[0], dir[1])
			if get_cell_atlas_coords(0,  Vector2i(curr+dir_vec)) == get_cell_atlas_coords(0, Vector2i(0,-2)) and get_cell_atlas_coords(0,  Vector2i(curr+(dir_vec*2))) == get_cell_atlas_coords(0, Vector2i(0,-3)):
				set_cell(0,  Vector2i(curr+dir_vec), 0, Vector2i(0, 0))
		if len(rdf_stack) > 0 and rdf_stack[0] != null:
			set_cell(0, rdf_stack.back(), 0, Vector2i(2, 0))
			
func to_3d():
	
	var blue = get_cell_atlas_coords(0, Vector2i(0, -3))
	var black = get_cell_atlas_coords(0, Vector2i(0, 0))
	
	for i in range(global.width):
		for j in range(global.height):
			var num = 0
			var sur = get_surrounding_cells(Vector2i(i,j))
			#for any given cell, counts how many blue tiles are around it
			for o in sur:
				if get_cell_atlas_coords(0, o) == blue:
					num += 1
			#checks to see if cell is black and records it in an array
			if get_cell_atlas_coords(0, Vector2i(i,j)) == black:
				steps.append("black")		
			
			#checks to see if a piece is an end piece and records its direction in an array
			elif num == 1:
				if get_cell_atlas_coords(0, sur[0]) == blue:
					steps.append("endRight")
				elif get_cell_atlas_coords(0, sur[1]) == blue:
					steps.append("endDown")
				elif get_cell_atlas_coords(0, sur[2]) == blue:
					steps.append("endLeft")	
				elif get_cell_atlas_coords(0, sur[3]) == blue:
					steps.append("endUp")
					
			#checks to see if a piece is a corner or straight piece and records its direction in an arrray
			elif num == 2:
				if get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, sur[1]) and get_cell_atlas_coords(0, sur[0]) == blue:
					steps.append("cornerDownRight")
				elif get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, sur[2]) and get_cell_atlas_coords(0, sur[1]) == blue:
					steps.append("cornerDownLeft")
				elif get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, sur[3]) and get_cell_atlas_coords(0, sur[2]) == blue:
					steps.append("cornerUpLeft")	
				elif get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, sur[0]) and get_cell_atlas_coords(0, sur[3]) == blue:
					steps.append("cornerUpRight")	
				elif get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, sur[3]) and get_cell_atlas_coords(0, sur[1]) == blue:
					steps.append("pathVert")	
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, sur[2]) and get_cell_atlas_coords(0, sur[0]) == blue:
					steps.append("pathHorz")	
					
			#checks to see if a piece is a t piece and records its direction in an arrray
			elif num == 3:
				if get_cell_atlas_coords(0, sur[0]) == black:
					steps.append("tLeft")
				elif get_cell_atlas_coords(0, sur[1]) == black:
					steps.append("tUp")
				elif get_cell_atlas_coords(0, sur[2]) == black:
					steps.append("tRight")	
				elif get_cell_atlas_coords(0, sur[3]) == black:
					steps.append("tDown")
			#checks to see if the piece is a cross piece
			elif num == 4:
				steps.append("cross")
			
	#sends the array to the 3d node
	done.emit(steps)
	#sets the start cell back to red on the 2d map
	set_cell(0, Vector2i(start_x + 1,start_y), 0, Vector2i(2,0))
