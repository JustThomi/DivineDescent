extends CharacterBody2D

@onready var animation := $AnimatedSprite2D
# FOR DEBUG ONLY
@export var player : CharacterBody2D

const SPEED = 50.0
var direction := Vector2.ZERO
var health := 30

enum {
	IDLE,
	RUN,
}
var state = RUN

func take_damage(dmg : int):
	health -= dmg
	print("au")

func get_player_direction():
	direction = (player.position - position).normalized()

# flip sprite TEMP FIX
func flip_sprite():
	if direction.x < 0:
		animation.flip_h = true
	elif direction.x > 0:
		animation.flip_h = false

func run():
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()

func _physics_process(_delta):
	get_player_direction()
	
	# temp killing lol
	if health <= 0:
		queue_free()
	
	match state:
		IDLE:
			velocity = Vector2.ZERO
			animation.play("idle")
		RUN:
			flip_sprite()
			run()
			animation.play("run")
