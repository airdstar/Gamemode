extends CanvasLayer

func _ready() -> void:
	pass

func assign_player(player : Player) -> void:
	$VBoxContainer/RichTextLabel.text = player.username
	$VBoxContainer/HBoxContainer/HealthBar.value = player.body.health_component.amount
	player.body.health_component.health_changed.connect(update_health)

func update_health(new_health : int):
	$VBoxContainer/HBoxContainer/HealthBar.value = new_health
