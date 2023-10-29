extends GridMap
var n = 0

	
	
func _on_tile_map_done():
	n = 0
	for i in range(global.width):
		for j in range(global.height):
			set_cell_item(Vector3i(i, 0, j), -1)
	for i in range(global.width):
		for j in range(global.height):
			if global.steps[n] == "black":
				pass
				
			elif global.steps[n] == "pathVert":	
				set_cell_item(Vector3i(i, 0, j), 3, 16)
				
			elif global.steps[n] == "pathHorz":	
				set_cell_item(Vector3i(i, 0, j), 3, 0)
				
			elif global.steps[n] == "cornerDownLeft":
				set_cell_item(Vector3i(i, 0, j), 4, 0)	
				
			elif global.steps[n] == "cornerDownRight":
				set_cell_item(Vector3i(i, 0, j), 4, 16)	
				
			elif global.steps[n] == "cornerUpLeft":
				set_cell_item(Vector3i(i, 0, j), 4, 22)	
				
			elif global.steps[n] == "cornerUpRight":
				set_cell_item(Vector3i(i, 0, j), 4, 10)	
				
			elif global.steps[n] == "endLeft":	
				set_cell_item(Vector3i(i, 0, j), 2, 22)
				
			elif global.steps[n] == "endRight":	
				set_cell_item(Vector3i(i, 0, j), 2, 16)
				
			elif global.steps[n] == "endUp":	
				set_cell_item(Vector3i(i, 0, j), 2, 10)
				
			elif global.steps[n] == "endDown":	
				set_cell_item(Vector3i(i, 0, j), 2, 0)
				
			elif global.steps[n] == "tLeft":	
				set_cell_item(Vector3i(i, 0, j), 1, 0)
				
			elif global.steps[n] == "tRight":	
				set_cell_item(Vector3i(i, 0, j), 1, 10)
				
			elif global.steps[n] == "tUp":	
				set_cell_item(Vector3i(i, 0, j), 1, 22)
				
			elif global.steps[n] == "tDown":	
				set_cell_item(Vector3i(i, 0, j), 1, 16)
				
			elif global.steps[n] == "cross":	
				set_cell_item(Vector3i(i, 0, j), 0, 0)
				
			n += 1






