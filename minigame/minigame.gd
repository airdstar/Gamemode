extends Resource
class_name Minigame

@export_category("Player Settings")

@export_enum("Third Person", "First Person", "Special") var camera : int
#@export var movement_type : movement

@export_category("Minigame Settings")

@export_enum("First", "Pass", "Alive") var winner : int
@export var health : bool
@export var use_lobby : bool = false
@export var fixed_map : bool = true
@export var maps : Array[int]
