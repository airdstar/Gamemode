extends Control

func _on_host_pressed() -> void:
	get_parent().open_lobby()
	Game.username = $Input/Username.text
	Network.call_deferred("host_lobby")
	queue_free()

func _on_join_pressed() -> void:
	get_parent().open_lobby()
	Game.username = $Input/Username.text
	Network.call_deferred("join_lobby", $Input/Ip.text)
	queue_free()
