extends Node3D

@onready var player_camera = $CharacterBody3D/Head/Player_Camera3D
@onready var fixed_camera = $grid/Camera3D

signal freecam


func _ready():
	#sets the camera to the fixed camera when the application runs
	fixed_camera.current = true


func _process(delta):
	#checks which camera is the current camera and switches to the other
	#when "t" is pressed
	if Input.is_action_just_released("toggle_camera"):
		if fixed_camera.is_current():
			player_camera.current = true
			freecam.emit(true)
		else:
			fixed_camera.current = true
			freecam.emit(false)
