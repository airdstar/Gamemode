extends CanvasLayer

@onready var list_panel = $ListPanel
@onready var list = $ListPanel/List

var scores : Array[RichTextLabel]

func _ready() -> void:
	Network.player_joined.connect(add_player)
	hide()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("open_list"):
		show()
	elif Input.is_action_just_released("open_list"):
		hide()

func create_list() -> void:
	for n in Game.players:
		create_listing(n)

func create_listing(player : Player) -> void:
	list_panel.size.y += 36
	var hbox = HBoxContainer.new()
	hbox.name = player.name
	list.add_child(hbox)
	var label1 = RichTextLabel.new()
	label1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label1.fit_content = true
	label1.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label1.text = player.username
	
	var label2 = RichTextLabel.new()
	label2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label2.fit_content = true
	label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label2.text = str(player.score)
	
	scores.append(label2)
	
	hbox.add_child(label1)
	hbox.add_child(label2)
	
	player.change_score.connect(change_score)

func add_player(id : int) -> void:
	var _player = Game.find_player(id)
	if _player != null:
		if _player.is_multiplayer_authority():
			create_list()
		else:
			create_listing(_player)

func change_score(id : int, score : int) -> void:
	for n in list.get_children():
		if n.name.to_int() == id:
			n.get_child(1).text = str(score)
			break

func remove_player(id : int) -> void:
	list_panel.size.y -= 36

func update_username(id : int, username : String):
	for n in list.get_children():
		if n.name.to_int() == id:
			n.get_child(0).text = username
