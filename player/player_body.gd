extends CharacterBody3D

@export var third_person_camera : PhantomCamera3D
@export var movement_component : Movement
@export var health_component : Health

@export var tools : Array[Tool]

func _ready() -> void:
	spawn()

func death() -> void:
	health_component.health_changed.emit(0)
	$MeshInstance3D.hide()
	movement_component.freeze = true
	await get_tree().create_timer(3).timeout
	spawn()

func spawn() -> void:
	$MeshInstance3D.show()
	movement_component.freeze = false
	health_component.heal(health_component.max)
	velocity = Vector3.ZERO
	position = Game.get_spawn_point()
