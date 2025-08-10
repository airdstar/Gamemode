extends Node
class_name Movement

var body : CharacterBody3D
var active_camera : PhantomCamera3D
var freeze : bool = false

func _ready() -> void:
	body = get_parent()
	active_camera = get_parent().third_person_camera
