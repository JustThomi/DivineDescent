extends CharacterBody2D

# TODO add camera script for better experience
@onready var animation := $AnimatedSprite2D
@onready var hitbox := $HitBox
@onready var weapon_holder := $Weapons

# TEMP ANIM FOR TESTING 
@onready var animation_player := $AnimationPlayer

const SPEED := 100
const ACCELERATION := 500
const FRICTION := 500
const ROLL_SPEED := 140

var direction : Vector2
var roll_vector : Vector2
var weapon : Node2D # will reference current equiped weapon 

var sword : Node2D
var staff : Node2D 

var health = 100

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

func heal(hp):
	health = min(hp + health, 100)

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
	
	if Input.is_action_just_pressed("weapon_1"):
		weapon = sword
		sword.show()
		staff.hide()
	
	if Input.is_action_just_pressed("weapon_2"):
		weapon = staff
		weapon_holder.rotation = 0
		sword.hide()
		staff.show()

func _ready():
	randomize()
	sword = weapon_holder.get_child(0)
	staff = weapon_holder.get_child(1)
	weapon = sword

func _physics_process(delta):
	get_input()
	
	if weapon.get_name() == "Sword":
		weapon_holder.look_at(get_global_mouse_position())
	
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
