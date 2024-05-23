extends CharacterBody2D

# TODO: add boss logic
@onready var projectile_container := $ProjectileContainer
@onready var attack_timer := $AttackTimer
@onready var animation := $AnimatedSprite2D
var player : CharacterBody2D

const SPEED = 10.0
var direction := Vector2.ZERO
var health := 600

var attack_directions : Array = [Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1), Vector2(-1, 0), Vector2(1, -1)]
var fireball : PackedScene =  preload("res://src/actors/player/weapons/fire_ball.tscn")

enum {
	IDLE,
	RUN,
	ATTACK,
}
var state = RUN

func take_damage(dmg : int):
	health -= dmg

func get_player_direction():
	direction = (player.global_position - global_position).normalized()

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

# TODO: FINISH THIS
func fire_attack():
	for dir in attack_directions:
		var f = fireball.instantiate()
		f.direction = dir
		projectile_container.add_child(f)
		f.position = position

# I promise this will be done better later
func _ready():
	player = get_parent().get_parent().get_parent().get_parent().get_node("Player")

func _physics_process(_delta):
	get_player_direction()
	
	# temp killing lol
	if health <= 0:
		SceneManager.boss_defeated.emit()
		queue_free()
	
	match state:
		IDLE:
			velocity = Vector2.ZERO
			animation.play("idle")
		RUN:
			flip_sprite()
			run()
			animation.play("run")
		ATTACK:
#			fire_attack()
			state = RUN

func _on_attack_timer_timeout():
	print("ATTACK")
	state = ATTACK
	attack_timer.start()
