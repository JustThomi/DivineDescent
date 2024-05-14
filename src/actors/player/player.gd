extends CharacterBody2D

# TODO add camera script for better experience
@onready var animation := $AnimatedSprite2D
@onready var hitbox := $HitBox

# TEMP ANIM FOR TESTING ROLL
@onready var animation_player := $AnimationPlayer

const SPEED := 100
const ACCELERATION := 500
const FRICTION := 500
const ROLL_SPEED := 140

var direction : Vector2
var roll_vector : Vector2
var weapon # will reference current equiped weapon 

# enum state machine, too lazy to do it right
enum {
	IDLE,
	RUN,
	ROLL,
}
var state = IDLE

# flip sprite TEMP FIX
func flip_sprite():
	if direction.x < 0:
		animation.flip_h = true
	elif direction.x > 0:
		animation.flip_h = false

func roll():
	velocity = roll_vector * (ROLL_SPEED + SPEED)
	animation_player.play("roll")
	hitbox.monitoring = false
	move_and_slide()

func get_input():
	direction.x = Input.get_axis("left", "right")
	direction.y = Input.get_axis("up", "down")

	if direction != Vector2.ZERO:
		state = RUN
		roll_vector = direction

	if Input.is_action_just_pressed("roll"):
		if state != ROLL:
			$RollTimer.start(0.3)
			state = ROLL
	
	# ATTACK outside of state machine to avoid adding a state stack
	if Input.is_action_just_pressed("basic_attack"):
		weapon.basic_attack()
	
	if Input.is_action_just_pressed("special_attack"):
		weapon.special_attack()

func _ready():
	randomize()
	weapon = $Weapons.get_child(0)

func _physics_process(delta):
	get_input()
	weapon.move(get_global_mouse_position())
	
	match state:
		IDLE:
			velocity = Vector2.ZERO
			animation.play("idle")
		ROLL:
			roll()
		RUN:
			flip_sprite()
			if direction:
				velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
				animation.play('run')
			else:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			move_and_slide()

func _on_roll_timer_timeout():
	$RollTimer.stop()
	hitbox.monitoring = true
	state = IDLE
