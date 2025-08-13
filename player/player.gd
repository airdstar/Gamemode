extends Node
class_name Player

@export var body : CharacterBody3D
@export var third_person_camera : PhantomCamera3D
@export var first_person_camera : PhantomCamera3D
@export var nametag : MeshInstance3D

@export var mouse_sensitivity : float = 0.086

@export var username : String
@export var score : int = 0

var active_camera : PhantomCamera3D



signal change_score
signal player_loaded

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		Game.player = self
		username = Game.username
		Game.rpc("update_username", name.to_int(), username)

func _ready() -> void:
	if is_multiplayer_authority():
		Game.hud.assign_player(self)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		#first_person_camera.priority = 1
		third_person_camera.priority = 2
	set_nametag(username)

func _process(delta : float) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("exit"):
			Network.leave_lobby(int(name))
			get_tree().quit()

func update_score(change : int) -> void:
	if is_multiplayer_authority():
		score += change
	change_score.emit(name.to_int(), score)

func set_nametag(_username : String):
	if !is_multiplayer_authority():
		nametag.mesh.text = _username
	else:
		nametag.mesh.text = ""

func _unhandled_input(event: InputEvent) -> void:
	if third_person_camera.is_active() and event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3

		# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
		pcam_rotation_degrees = third_person_camera.get_third_person_rotation_degrees()


		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity

		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, -80, 50)

		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity

		# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, 0, 360)

		third_person_camera.set_third_person_rotation_degrees(pcam_rotation_degrees)
		
		body.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
