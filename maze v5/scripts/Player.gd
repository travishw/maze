extends CharacterBody3D



const horz_velocity = 20
const vert_velocity = 20
const sensitivity = 0.01

var control = false

@onready var head = $Head
@onready var camera = $Head/Player_Camera3D


func _ready():
	#sets the mouse mode to captured on run so the mouse doesnt move off the 
	#application when moving the camera in freecam mode
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_main_freecam(freecam):
	#changes whether or not the user is able to control the freecam when 
	#the switch happens
	if freecam == true:
		control = true
	else:
		control = false	

func _unhandled_input(event):
	#closes the program when the user hits the "esc" key
	if event.is_action_pressed("ui_cancel"):
			get_tree().quit()
	#prevents user from moving when not in freecam mode
	if control ==true:
		#moves the users camera according to mouse movement when in freecam mode
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	#prevents user from moving when not in freecam mode
	if control == true:
		#sets the players vertical velocity
		if Input.is_action_pressed("down"):
			velocity.y = vert_velocity * -1
			
		elif Input.is_action_pressed("up"):
			velocity.y = vert_velocity 
			
		else:
			velocity.y = 0
			
		#gets which direction the user is moving based off of 
		#which movement keys are pressed
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		#sets the players horizontal velocity based on direction	
		velocity.x = lerp(velocity.x, direction.x * horz_velocity, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * horz_velocity, delta * 4.0)
		
		#moves the user
		move_and_slide()
	

	



