extends Node

@export var has_enemies : bool
@export var has_loot : bool

@onready var player_detector := $PlayerDetector

var enemie_locations : Node2D
var loot_locations : Node2D

func load_content():
	if has_enemies:
		enemie_locations = get_node("EnemieSpawns")
	elif has_loot:
		loot_locations = get_node("LootSpawns")

func spawn_enemies():
	pass

func spawn_loot():
	pass

func lock_doors():
	pass

func _ready():
	load_content()

func _on_player_detector_body_entered(_player):
	if has_enemies:
		spawn_enemies()
	if has_loot:
		spawn_loot()
	
	lock_doors()
