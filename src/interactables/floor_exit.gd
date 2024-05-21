extends Area2D

func _on_body_entered(_player):
	SceneManager.exit_level.emit()
