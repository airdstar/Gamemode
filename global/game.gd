extends Node

var hud : CanvasLayer
var lobby : Node
var current_dj : DJ

var players : Array[Player]
var player : Player
var username : String

func find_player(id : int) -> Player:
	for n in players:
		if n.name.to_int() == id:
			return n
	return null

func get_spawn_point() -> Vector3:
	var to_return : Vector3
	if !lobby.minigame_ongoing or !lobby.minigame.participating:
		to_return = Vector3(0,4,0)
	else:
		to_return = lobby.minigame.get_random_spawn()
		if !lobby.minigame.rules.use_lobby:
			to_return += Vector3(1000,0,1000)
	return to_return

@rpc("any_peer", "call_local")
func update_username(id : int, username : String):
	var _player = find_player(id)
	if _player != null:
		_player.set_nametag(username)
		lobby.playerlist.update_username(id, username)

@rpc("any_peer", "call_local")
func update_top_hud(text : String) -> void:
	hud.top.text = text

@rpc("any_peer", "call_local")
func jumpscare() -> void:
	pass
