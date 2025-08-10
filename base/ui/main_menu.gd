extends Control

func _on_host_pressed() -> void:
	get_parent().open_lobby()
	Game.username = $VBoxContainer/Username.text
	Network.call_deferred("host_lobby")
	queue_free()

func _on_join_pressed() -> void:
	get_parent().open_lobby()
	Game.username = $VBoxContainer/Username.text
	Network.call_deferred("join_lobby", $VBoxContainer/HBoxContainer/TextEdit.text)
	queue_free()
