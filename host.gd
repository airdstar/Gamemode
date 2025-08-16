extends Node

@onready var player_checker : Timer = $PlayerChecker
@onready var start_timer : Timer = $StartTimer
@onready var cooldown_timer : Timer = $Cooldown

var current_minigame : Minigame_Resource
var all_minigames : Array[Minigame_Resource]

func _ready() -> void:
	Game.lobby.end_timer.timeout.connect(start_cooldown, CONNECT_DEFERRED)
	var dir = DirAccess.open("res://minigame/resources/")
	if dir:
		dir.list_dir_begin()
		var current = dir.get_next()
		while current != "":
			if !current.ends_with(".import"):
				var minigame = ResourceLoader.load("res://minigame/resources/" + current)
				all_minigames.append(minigame)
			current = dir.get_next()
	start_cooldown()

func pick_minigame() -> void:
	if !all_minigames.is_empty():
		var pos_minigames : Array[Minigame_Resource]
		for n in all_minigames:
			if n.min_players <= Game.players.size():
				pos_minigames.append(n)
		
		current_minigame = pos_minigames.pick_random()

func minigame_cooldown_done() -> void:
	player_checker.start()

func check_playercount() -> void:
	if Game.players.size() >= 2:
		pick_minigame()
		if current_minigame != null:
			Game.lobby.rpc("accept_participants")
			Game.lobby.rpc("load_minigame", current_minigame.scene_path)
			Game.rpc("update_top_hud", "Loading minigame")
			start_timer.start()
		else:
			Game.rpc("update_top_hud", "Issue occurred")
	else:
		player_checker.start()
		Game.rpc("update_top_hud", "Waiting for players...")

func start_minigame() -> void:
	Game.lobby.rpc("start_minigame")

func start_cooldown() -> void:
	cooldown_timer.start()
	Game.rpc("update_top_hud", "Waiting")
