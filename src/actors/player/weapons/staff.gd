extends Node2D

# bad solution to projectiles but will do for now
@export var player : CharacterBody2D

@onready var animation := $AnimationPlayer
var projectile_container : Node2D

var projectile: PackedScene = preload("res://src/actors/player/weapons/fire_ball.tscn")
var attack_directions : Array = [Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1), Vector2(-1, 0), Vector2(1, -1)]
var can_special_attack: bool = true


func basic_attack():
	animation.play("cast")
	
	var p = projectile.instantiate()
	p.position = player.position
	p.direction = (get_local_mouse_position() + position).normalized()
	projectile_container.add_child(p)

func special_attack():
	if can_special_attack:
		for dir in attack_directions:
			var f = projectile.instantiate()
			f.position = player.position
			f.direction = dir
			projectile_container.add_child(f)
		
		can_special_attack = false
		$Cooldown.start()

func _ready():
	# not the best solution...
	projectile_container = get_node("/root/Game/ProjectileContainer")

func _on_cooldown_timeout():
	can_special_attack = true
