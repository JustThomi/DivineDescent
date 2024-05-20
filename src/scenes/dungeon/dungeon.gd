extends Node2D

const SPAWN: PackedScene = preload("res://src/scenes/dungeon/rooms/spawn.tscn")
const MOB_ROOMS: Array = [preload("res://src/scenes/dungeon/rooms/mob_room0.tscn"), preload("res://src/scenes/dungeon/rooms/mob_room1.tscn")]
const SPECIAL_ROOM: PackedScene = preload("res://src/scenes/dungeon/rooms/special_room.tscn")
const BOSS_ROOM: PackedScene = preload("res://src/scenes/dungeon/rooms/boss_room.tscn")

const TILE_SIZE: int = 16
const FLOOR_TILE_INDEX := Vector2i(1, 1)
const RIGHT_WALL_TILE_INDEX := Vector2i(5, 0)
const LEFT_WALL_TILE_INDEX := Vector2i(0, 0)

@export var number_of_rooms: int = 8
@export var player: CharacterBody2D
var current_floor: int = 0

func _spawn_rooms() -> void:
	var previous_room: Node2D
	var special_room_spawned: bool = false

	for i in number_of_rooms:
		var room: Node2D

		if i == 0:
			room = SPAWN.instantiate()
			player.position = room.get_node("SpawnPoint").position
		else:
			if i == number_of_rooms - 1:
				room = BOSS_ROOM.instantiate()
			else:
				if (randi() % 3 == 0 and not special_room_spawned) or (i == number_of_rooms - 2 and not special_room_spawned):
					room = SPECIAL_ROOM.instantiate()
					special_room_spawned = true
				else:
					room = MOB_ROOMS[randi() % MOB_ROOMS.size()].instantiate()

			var previous_room_tilemap: TileMap = previous_room.get_node("Environment")
			var previous_room_door: Marker2D = previous_room.get_node("Exit")
			var exit_tile_pos: Vector2i = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2

			var corridor_height: int = randi() % 5 + 2
			for y in corridor_height:
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-2, -y + 1), 0, LEFT_WALL_TILE_INDEX, 0)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(-1, -y + 1), 0, FLOOR_TILE_INDEX, 0)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(0, -y + 1), 0, FLOOR_TILE_INDEX, 0)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2i(1, -y + 1), 0, RIGHT_WALL_TILE_INDEX, 0)

			var room_tilemap: TileMap = room.get_node("Environment")
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y / 2 * TILE_SIZE + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node("Entrance").position).x * TILE_SIZE

		add_child(room)
		previous_room = room

func _ready() -> void:
	current_floor += 1
	_spawn_rooms()
