extends Node
class_name DJ

@export var music_player : AudioStreamPlayer
@export var path : String

var songs : Array
var song_num := 0

func _ready() -> void:
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var current = dir.get_next()
		while current != "":
			if !current.ends_with(".import"):
				var song = ResourceLoader.load(path + "/" + current)
				songs.append(song)
			current = dir.get_next()
	songs.shuffle()
	get_new_song()


func set_dj() -> void:
	if Game.current_dj != null:
		Game.current_dj.music_player.stream_paused = true
	Game.current_dj = self
	get_new_song()

func get_new_song() -> void:
	if !songs.is_empty():
		music_player.stream = songs[song_num]
		if song_num != songs.size() - 1:
			song_num += 1
		else:
			song_num = 0
			songs.shuffle()
		play_song()

func play_song() -> void:
	if Game.current_dj == self:
		music_player.play()
		Game.hud.music.text = "[rainbow][wave]♩ " + music_player.stream.resource_path.get_file() + " ♩"
