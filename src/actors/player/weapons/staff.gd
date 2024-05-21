extends Node2D

# bad solution to projectiles but will do for now
@export var player : CharacterBody2D

@onready var animation := $AnimationPlayer
var projectile_container : Node2D

var projectile: PackedScene = preload("res://src/actors/player/weapons/fire_ball.tscn")
var can_special_attack: bool = true


func basic_attack():
	animation.play("cast")
	
	var p = projectile.instantiate()
	p.position = player.position
	p.direction = (get_local_mouse_position() + position).normalized()
	projectile_container.add_child(p)

func special_attack():
	print("DAMN SON THAT'S SPECIAL CAST")

func _ready():
	# not the best solution...
	projectile_container = get_node("/root/Game/ProjectileContainer")
