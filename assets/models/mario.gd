extends Node3D

@onready var anim : AnimationTree = $AnimationTree
@onready var ray_cast_3d : RayCast3D = $RayCast3D

func _ready() -> void:
	pass

func _process(_delta : float) -> void:
	
	if get_parent().is_on_floor():
		anim.set("parameters/State/transition_request", "Ground")
	else:
		anim.set("parameters/State/transition_request", "Air")
	if is_multiplayer_authority():
		if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
			if Input.is_action_pressed("move_forward"):
				rpc("update_animation", "parameters/Movement/transition_request", "Forward")
			else:
				rpc("update_animation", "parameters/Movement/transition_request", "Idle")
		
		if Input.is_action_pressed("move_left"):
			rpc("update_animation", "parameters/Movement/transition_request", "Left")
		elif Input.is_action_pressed("move_right"):
			rpc("update_animation", "parameters/Movement/transition_request", "Right")
		elif Input.is_action_pressed("move_forward"):
			rpc("update_animation", "parameters/Movement/transition_request", "Forward")
		else:
			rpc("update_animation", "parameters/Movement/transition_request", "Idle")

@rpc("any_peer","call_local")
func update_animation(place : String, animation : String) -> void:
	anim.set(place, animation)
