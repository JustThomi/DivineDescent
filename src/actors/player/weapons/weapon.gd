extends Node2D
class_name Weapon

@onready var animation := $AnimationPlayer

@export var ranged_weapon: bool = false
@export var rotation_offset: int = 0

var can_special_attack: bool = true
var basic_attack_damage = 10

func move(mouse_direction: Vector2) -> void:
	if ranged_weapon:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		rotation = mouse_direction.angle()
		if scale.y == 1 and mouse_direction.x < 0:
			scale.y = -1
		elif scale.y == -1 and mouse_direction.x > 0:
			scale.y = 1

func basic_attack():
	animation.play("swing")

func special_attack():
	print("DAMN SON THAT'S SPECIAL")

func _on_hurt_box_body_entered(body):
	body.take_damage(basic_attack_damage)
