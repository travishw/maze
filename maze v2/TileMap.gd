extends TileMap

var width = 40
var height = 40


var start_x = (width/2)
var start_y= ((height/2) - 1)


var generation_complete = false




func _unhandled_input(_event):
	if Input.is_action_pressed("space"):
		generation_complete = false
		_ready()
		

func _ready():
	set_cell(0, Vector2i(0,0), 0, Vector2i(8,0))
	set_cell(0, Vector2i(0,-1), 0, Vector2i(4,0))
	set_cell(0, Vector2i(0,-2), 0, Vector2i(6,0))
	set_cell(0, Vector2i(0,-3), 0, Vector2i(0,0))
	
	if width % 2 != 1:
		width -= 1
	if height % 2 != 1:
		height -= 1
	
	var x_scale = 1152/(width*32.0)
	var y_scale = 1152/(height*32.0)
	scale = Vector2(x_scale, y_scale)
	
	for i in range(width):
		for j in range(height):
			
			if i == 0 or j == 0 or i == width-1 or j == height-1:
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
	to_3d()

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
	if width % 2 != 1:
		width -= 1
	if height % 2 != 1:
		height -= 1
	for i in range(width):
		for j in range(height):
			if get_cell_atlas_coords(0, Vector2i(i,j)) == get_cell_atlas_coords(0, Vector2i(0, 0)):
				print("black")
			else:
				var sur = get_surrounding_cells(Vector2i(i,j))
				if get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0,sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):
					print("endRight")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					print("endDown")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					print("endleft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					print("endup")
					
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):
					print("cornerDownRight")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					print("cornerDownLeft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					print("cornerUpLeft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					print("cornerUpRight")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):	
					print("pathHorz")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					print("pathVert")
					
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, 0)):
					print("tDown")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					print("tleft")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					print("tUp")
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, 0)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):	
					print("tRight")
					
				elif get_cell_atlas_coords(0, sur[0]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[1]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[2]) == get_cell_atlas_coords(0, Vector2i(0, -3)) and get_cell_atlas_coords(0, sur[3]) == get_cell_atlas_coords(0, Vector2i(0, -3)):
					print("cross")
	set_cell(0, Vector2i(start_x + 1,start_y), 0, Vector2i(2,0))
