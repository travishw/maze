extends GridMap
	
func _on_tile_map_done(steps):
	var n = 0
	for i in range(global.width):
		for j in range(global.height):
			set_cell_item(Vector3i(i, 0, j), -1)
	for i in range(global.width):
		for j in range(global.height):
			if steps[n] == "black":
				pass
				
			elif steps[n] == "pathVert":	
				set_cell_item(Vector3i(i, 0, j), 3, 16)
				
			elif steps[n] == "pathHorz":	
				set_cell_item(Vector3i(i, 0, j), 3, 0)
				
			elif steps[n] == "cornerDownLeft":
				set_cell_item(Vector3i(i, 0, j), 4, 0)	
				
			elif steps[n] == "cornerDownRight":
				set_cell_item(Vector3i(i, 0, j), 4, 16)	
				
			elif steps[n] == "cornerUpLeft":
				set_cell_item(Vector3i(i, 0, j), 4, 22)	
				
			elif steps[n] == "cornerUpRight":
				set_cell_item(Vector3i(i, 0, j), 4, 10)	
				
			elif steps[n] == "endLeft":	
				set_cell_item(Vector3i(i, 0, j), 2, 22)
				
			elif steps[n] == "endRight":	
				set_cell_item(Vector3i(i, 0, j), 2, 16)
				
			elif steps[n] == "endUp":	
				set_cell_item(Vector3i(i, 0, j), 2, 10)
				
			elif steps[n] == "endDown":	
				set_cell_item(Vector3i(i, 0, j), 2, 0)
				
			elif steps[n] == "tLeft":	
				set_cell_item(Vector3i(i, 0, j), 1, 0)
				
			elif steps[n] == "tRight":	
				set_cell_item(Vector3i(i, 0, j), 1, 10)
				
			elif steps[n] == "tUp":	
				set_cell_item(Vector3i(i, 0, j), 1, 22)
				
			elif steps[n] == "tDown":	
				set_cell_item(Vector3i(i, 0, j), 1, 16)
				
			elif steps[n] == "cross":	
				set_cell_item(Vector3i(i, 0, j), 0, 0)
				
			n += 1






