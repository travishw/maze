extends TileMap

signal done

var start_x = (global.width/2)
var start_y= ((global.height/2) - 1)


var generation_complete = false
var steps_fin = true

@onready var tile_map = $"."


func _unhandled_input(_event):
	if Input.is_action_pressed("space"):
		generation_complete = false
		global.steps = []
		_ready()
	if Input.is_action_pressed("toggle"):
		tile_map.show()
	if Input.is_action_just_released("toggle"):
		tile_map.hide()
		
		
func _ready():
	set_cell(0, Vector2i(0,0), 0, Vector2i(8,0))
	set_cell(0, Vector2i(0,-1), 0, Vector2i(4,0))
	set_cell(0, Vector2i(0,-2), 0, Vector2i(6,0))
	set_cell(0, Vector2i(0,-3), 0, Vector2i(0,0))
	
	if global.width % 2 != 1:
		global.width -= 1
	if global.height % 2 != 1:
		global.height -= 1
	
	var x_scale = 1152/(global.width*32.0)
	var y_scale = 1152/(global.height*32.0)
	scale = Vector2(x_scale, y_scale)
	
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
	
	randomize()
	

	set_cell(0, Vector2i(start_x,start_y), 0, Vector2i(6,0))

	
	rdf_init()
	
	while not generation_complete:
		rdf_step()
	

var rdf_stack = []
func rdf_init():
	
	var offsets = [[1,0], [-1, 0], [0, 1], [0, -1]]
	
	for o in offsets:
		if get_cell_atlas_coords(0, Vector2i(start_x + o[0], start_y + o[1])) == get_cell_atlas_coords(0, Vector2i(0,-1)):
			rdf_stack.push_back(Vector2(start_x + o[0], start_y + o[1]))
		set_cell(0,  rdf_stack[0], 0, Vector2i(2, 0))
		
		
func rdf_step():
	if len(rdf_stack) <= 0:
		generation_complete = true
		to_3d()
		return
	
	var curr = rdf_stack.pop_back()
	var next
	var found = false
	
	# check neighbors in random order
	var check_order = [[2,0], [-2, 0], [0, 2], [0, -2]]
	check_order.shuffle()
	for val in check_order:
		next = Vector2(val[0], val[1])
		if get_cell_atlas_coords(0, Vector2i(curr + next)) == get_cell_atlas_coords(0, Vector2i(0,-1)):
			found = true
			break
	
	if found:
		rdf_stack.push_back(curr)
		set_cell(0, curr + (next/2), 0, Vector2i(6, 0))
		set_cell(0, curr + next, 0, Vector2i(2, 0))
		set_cell(0, curr, 0, Vector2i(6, 0))
		rdf_stack.push_back(curr+next)
	else:
		set_cell(0, curr, 0, Vector2i(0, 0))
		for dir in [[1,0], [0,1], [-1,0], [0,-1]]:
			var dir_vec = Vector2(dir[0], dir[1])
			if get_cell_atlas_coords(0,  Vector2i(curr+dir_vec)) == get_cell_atlas_coords(0, Vector2i(0,-2)) and get_cell_atlas_coords(0,  Vector2i(curr+(dir_vec*2))) == get_cell_atlas_coords(0, Vector2i(0,-3)):
				set_cell(0,  Vector2i(curr+dir_vec), 0, Vector2i(0, 0))
		if len(rdf_stack) > 0 and rdf_stack[0] != null:
			set_cell(0, rdf_stack.back(), 0, Vector2i(2, 0))
			
func to_3d():
	if global.width % 2 != 1:
		global.width -= 1
	if global.height % 2 != 1:
		global.height -= 1
	for i in range(global.width):
		for j in range(global.height):
			if get_cell_atlas_coords(0, Vector2i(i,j)) == get_cell_atlas_coords(0, Vector2i(0, 0)):
				global.steps.append("black")
			else:
				var sur = get_surrounding_cells(Vector2i(i,j))
				if get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0,sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):
					global.steps.append("endRight")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					global.steps.append("endDown")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					global.steps.append("endleft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					global.steps.append("endup")
					
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):
					global.steps.append("cornerDownRight")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					global.steps.append("cornerDownLeft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					global.steps.append("cornerUpLeft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					global.steps.append("cornerUpRight")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					global.steps.append("pathHorz")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					global.steps.append("pathVert")
					
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):
					global.steps.append("tDown")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					global.steps.append("tLeft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					global.steps.append("tUp")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					global.steps.append("tRight")
					
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):
					global.steps.append("cross")
	done.emit()
	set_cell(0, Vector2i(start_x + 1,start_y), 0, Vector2i(2,0))
	
	
	
