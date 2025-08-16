extends CharacterBody3D

@export var third_person_camera : PhantomCamera3D
@export var movement_component : Movement
@export var health_component : Health

@export var tools : Array[Tool]

var force_respawned : bool = false

func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	call_deferred("spawn")

func death() -> void:
	health_component.health_changed.emit(0)
	$Mario.hide()
	movement_component.freeze = true
	await get_tree().create_timer(0.5).timeout
	if !force_respawned:
		spawn()

func spawn() -> void:
	$Mario.show()
	movement_component.freeze = false
	health_component.heal(health_component.max)
	velocity = Vector3.ZERO
	position = Game.get_spawn_point()
