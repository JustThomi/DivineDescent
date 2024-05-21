extends Area2D

const speed := 200.0
var direction := Vector2.ZERO
var damage = 15

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(enemy):
	enemy.take_damage(damage)
	queue_free()
