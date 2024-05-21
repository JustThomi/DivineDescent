extends Area2D

var amount = 10

func _on_body_entered(player):
	player.heal(amount)
	queue_free()
