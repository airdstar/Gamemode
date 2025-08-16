extends CanvasLayer

@onready var health_bar : TextureProgressBar = $Stats/HealthBar
@onready var music : RichTextLabel = $Music
@onready var top : RichTextLabel = $Top

func _ready() -> void:
	pass

func assign_player(player : Player) -> void:
	show()
	$Stats/Name.text = player.username
	health_bar.value = player.body.health_component.amount
	player.body.health_component.health_changed.connect(update_health)

func update_health(new_health : int):
	health_bar.value = new_health
