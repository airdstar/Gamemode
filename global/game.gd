extends Node

var lobby : Node
var players : Array[Player]
var player : Player
var username : String

func find_player(id : int) -> Player:
	for n in players:
		if n.name.to_int() == id:
			return n
	return null

func get_spawn_point() -> Vector3:
	var to_return = Vector3(0,4,0)
	return to_return

@rpc("any_peer", "call_local")
func update_username(id : int, username : String):
	var _player = find_player(id)
	if _player != null:
		_player.set_nametag(username)
		lobby.playerlist.update_username(id, username)
