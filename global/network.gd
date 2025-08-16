extends Node

var peer = ENetMultiplayerPeer.new()

signal player_joined

func host_lobby() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player(1)
	multiplayer.allow_object_decoding = true
	Game.player.set_host()

func add_player(id : int) -> void:
	var player = preload("res://player/player.tscn").instantiate()
	player.name = str(id)
	get_node(^"/root/Main").add_child(player)
	rpc("_player_joined", id)

func join_lobby(ip : String) -> void:
	peer.create_client(ip, 1027)
	multiplayer.multiplayer_peer = peer

func leave_lobby(id : int) -> void:
	rpc("del_player", id)

@rpc("any_peer", "call_local")
func del_player(id : int) -> void:
	Game.find_player(id).queue_free()
	Game.lobby.playerlist.remove_player(id)

@rpc("any_peer", "call_local")
func _player_joined(id : int) -> void:
	for n in get_node(^"/root/Main").get_children():
		if n is Player and !Game.players.has(n):
			Game.players.append(n)
	player_joined.emit(id)

@rpc("any_peer", "call_local")
func get_host_info() -> void:
	Game.rpc_id(multiplayer.get_remote_sender_id(), "update_top_hud", Game.hud.top.text)
	if Game.lobby.accepting_participants:
		rpc_id(multiplayer.get_remote_sender_id(), "accept_participants")
	var minigame = Game.player.host.current_minigame
	if minigame != null:
		rpc_id(multiplayer.get_remote_sender_id(), "load_minigame", minigame)
	if Game.lobby.minigame_ongoing:
		Game.lobby.rpc_id(multiplayer.get_remote_sender_id(), "set_end_time", Game.lobby.end_timer.time_left)
