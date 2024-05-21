extends Node

@export var has_enemies : bool
@export var has_loot : bool

@onready var player_detector := $PlayerDetector

var enemy_locations : Node2D
var enemy_container : Node2D
var enemies : Array = [preload("res://src/actors/mobs/skeleton.tscn")]
var loot_locations : Node2D
#var loot : Array = [preload("res://src/interactables/potion.tscn")]

func load_content():
	if has_enemies:
		enemy_locations = get_node("EnemySpawns")
		enemy_container = get_node("EnemyContainer")
	elif has_loot:
		loot_locations = get_node("LootSpawns")

func spawn_enemies():
	for points in enemy_locations.get_children():
		var e = enemies[randi() % enemies.size()].instantiate()
		e.position = points.position
		enemy_container.add_child(e)

func spawn_loot():
	pass

func lock_doors():
	player_detector.monitorable = false
	player_detector.monitoring = false

func _ready():
	load_content()

# TODO: add boss room/special room logic
func _on_player_detector_body_entered(_player):
	if has_enemies:
		call_deferred("spawn_enemies")
	if has_loot:
		spawn_loot()
	
	call_deferred("lock_doors")
