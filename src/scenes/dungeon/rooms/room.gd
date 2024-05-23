extends Node

@export var has_enemies : bool
@export var has_loot : bool
@export var is_boss_room : bool

@onready var player_detector := $PlayerDetector

var enemy_locations : Node2D
var enemy_container : Node2D
var enemies : Array = [preload("res://src/actors/skeleton.tscn")]
var loot_locations : Node2D
var loot_container : Node2D
var loot_items : Array = [preload("res://src/interactables/health_pickup.tscn")]
var boss_spawn : Node2D
var bosses : Array = [preload("res://src/actors/mobs/demon_boss.tscn")]

func load_content():
	if has_enemies:
		enemy_locations = get_node("EnemySpawns")
		enemy_container = get_node("EnemyContainer")
	if has_loot:
		loot_locations = get_node("LootSpawns")
		loot_container = get_node("LootContainer")
	if is_boss_room:
		boss_spawn = get_node("BossSpawn")

func spawn_enemies():
	for points in enemy_locations.get_children():
		var e = enemies[randi() % enemies.size()].instantiate()
		e.position = points.position
		enemy_container.add_child(e)

func spawn_loot():
	for points in loot_locations.get_children():
		var l = loot_items[randi() % loot_items.size()].instantiate()
		l.position = points.position
		loot_container.add_child(l)

func spawn_boss():
	var spawn_point = boss_spawn.get_child(0)
	var b = bosses[randi() % bosses.size()].instantiate()
	b.position = spawn_point.position
	boss_spawn.add_child(b)

func lock_doors():
	player_detector.monitorable = false
	player_detector.monitoring = false

func _ready():
	load_content()
	if has_loot:
		spawn_loot()

# TODO: add boss room/special room logic
func _on_player_detector_body_entered(_player):
	if has_enemies:
		call_deferred("spawn_enemies")
		call_deferred("lock_doors")
	if is_boss_room:
		call_deferred("spawn_boss")
		call_deferred("lock_doors")
