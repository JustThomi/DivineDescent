extends Area2D

var can_exit = false

func _ready():
	SceneManager.boss_defeated.connect(_on_boss_defeated)

func _on_boss_defeated():
	can_exit = true

func _on_body_entered(_player):
	if can_exit:
		SceneManager.exit_level.emit()
