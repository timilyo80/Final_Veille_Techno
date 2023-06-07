extends KinematicBody2D

const DeathEffect = preload("res://BatDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var ID = 0

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE
var permanence = Permanence

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetection
onready var hurtbox = $Hurthbox
onready var softColision = $SoftCollision

func _ready():
	if permanence.is_Exist(get_tree().current_scene.name, ID) != -1:
		queue_free()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			Seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
			
	if softColision.is_colliding():
		velocity += softColision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func Seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurthbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var deathEffect = DeathEffect.instance()
	get_parent().add_child(deathEffect)
	deathEffect.global_position = global_position
	permanence.unexist(get_tree().current_scene.name, ID)
