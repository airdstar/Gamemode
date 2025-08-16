extends Node3D

var minigame : Node3D
@export var minigame_ongoing : bool = false
@export var accepting_participants : bool = false

@onready var playerlist = $Playerlist
@onready var end_timer : Timer = $EndTimer

func _ready() -> void:
	$DJ.set_dj()

func _process(_delta : float) -> void:
	if minigame_ongoing:
		Game.hud.top.text = "%.2f" % end_timer.time_left

func give_point(area: Area3D) -> void:
	area.get_parent().get_parent().update_score(1)

func oob(area: Area3D) -> void:
	area.get_parent().death()

@rpc("any_peer", "call_local")
func load_minigame(minigame_path : String) -> void:
	var node = load(minigame_path)
	minigame = node.instantiate()
	add_child(minigame)
	if accepting_participants:
		minigame.participating = true

@rpc("any_peer", "call_local")
func accept_participants() -> void:
	accepting_participants = true

@rpc("any_peer", "call_local")
func start_minigame() -> void:
	accepting_participants = false
	minigame_ongoing = true
	
	end_timer.wait_time = minigame.rules.time
	end_timer.start()
	
	Game.player.body.spawn()
	minigame.dj.set_dj()
	minigame.start()

@rpc("any_peer","call_local")
func set_end_time(time) -> void:
	end_timer.wait_time = time
	end_timer.start()

func end_minigame() -> void:
	minigame.end()
	minigame_ongoing = false
	if minigame != null:
		if minigame.win:
			Game.player.update_score(1)
		minigame.queue_free()
		minigame = null
	Game.hud.top.text = "Waiting"
	Game.player.body.spawn()
	$DJ.set_dj()
