extends CanvasLayer

func _ready() -> void:
	pass

func assign_player(player : Player) -> void:
	show()
	$Stats/Name.text = player.username
	$Stats/HealthBar.value = player.body.health_component.amount
	player.body.health_component.health_changed.connect(update_health)

func update_health(new_health : int):
	$Stats/HealthBar.value = new_health

func new_song_playing() -> void:
	pass
