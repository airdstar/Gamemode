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

func get_player(id : int) -> Control:
	for n in list.get_children():
		if n.name.to_int() == id:
			return n
	return null

func create_list() -> void:
	for n in Game.players:
		create_listing(n)

func create_listing(player : Player) -> void:
	if list.get_child_count() > 0:
		list_panel.size.y += 36
	var hbox = HBoxContainer.new()
	hbox.name = player.name
	list.add_child(hbox)
	var label1 = RichTextLabel.new()
	label1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label1.fit_content = true
	label1.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label1.bbcode_enabled = true
	var text : String
	if player.is_multiplayer_authority():
		text = "[color=cyan]"
	text += player.username
	label1.text = text
	
	var label2 = RichTextLabel.new()
	label2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label2.fit_content = true
	label2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label2.text = str(player.score)
	label2.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	scores.append(label2)
	
	hbox.add_child(label1)
	hbox.add_child(label2)
	
	player.change_score.connect(change_score)
	sort(hbox)

func add_player(id : int) -> void:
	var _player = Game.find_player(id)
	if _player != null:
		if _player.is_multiplayer_authority():
			create_list()
		else:
			create_listing(_player)

func remove_player(id : int) -> void:
	list_panel.size.y -= 36
	var player = get_player(id)
	if player != null:
		player.queue_free()

func sort(player : Control) -> void:
	var num = player.get_index() - 1
	while num >= 0:
		if list.get_child(num).get_child(1).text.to_int() < player.get_child(1).text.to_int():
			list.move_child(player, num)
		num -= 1

func change_score(id : int, score : int) -> void:
	var player = get_player(id)
	if player != null:
		player.get_child(1).text = str(score)
		sort(player)

func update_username(id : int, username : String):
	var player = get_player(id)
	if player != null:
		player.get_child(0).text = username
