extends Node2D
class_name Weapon

@export var ranged_weapon: bool = false
@export var rotation_offset: int = 0

var can_special_attack: bool = true

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
	print("basic AF")

func special_attack():
	print("DAMN SON THAT'S SPECIAL")
