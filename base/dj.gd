extends Node
class_name DJ

@export var music_player : AudioStreamPlayer
@export var path : String

func set_dj() -> void:
	Game.current_dj.stream_paused = true
	Game.current_dj = self
	music_player.play()

func get_new_song() -> void:
	pass

@rpc("any_peer", "call_local")
func play_new_song(song : AudioStreamOggVorbis) -> void:
	music_player.stream = song
	if Game.current_dj == self:
		music_player.play()
