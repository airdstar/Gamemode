extends Node3D
class_name Minigame

@export var rules : Rules
@export var spawn_points : Array[Node]
@export var dj : DJ

var participating : bool = false
var win : bool = false

func _ready() -> void:
	if rules.use_lobby:
		pass
	else:
		position += Vector3(1000,0,1000)
	
	if rules.teams > 1:
		pass

func start() -> void:
	pass

## Use for cleanup
func end() -> void:
	pass

func get_random_spawn() -> Vector3:
	var to_return = spawn_points.pick_random().position
	return to_return
