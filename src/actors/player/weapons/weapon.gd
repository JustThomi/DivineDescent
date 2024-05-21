extends Node2D

@onready var animation := $AnimationPlayer

var can_special_attack: bool = true
var basic_attack_damage = 10

func basic_attack():
	animation.play("swing")

func special_attack():
	print("DAMN SON THAT'S SPECIAL")

func _on_hurt_box_body_entered(body):
	body.take_damage(basic_attack_damage)
