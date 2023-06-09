extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const ROLL_SPEED = 100
const FRICTION = 500
const Slash = preload("res://NewItems/Proj-Slash.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK,
	SHOOT
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var permanence = Permanence

onready var hitBox = $HitboxPivot/Hitbox/CollisionShape2D
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox  = $HitboxPivot/Hitbox
onready var hurtbox = $Hurthbox

func _ready():
	position.x = permanence.LevelposX
	position.y = permanence.LevelposY
	stats.connect("no_health", self, "queue_free")
	hitBox.disabled = true
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		SHOOT:
			shoot_state(delta)
			
	if $Timer_Slash.time_left != 0:
		stats.coolDown($Timer_Slash.time_left)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Shoot/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("shoot") && $Timer_Slash.time_left == 0:
		state = SHOOT
		$Timer_Slash.start()
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll_state(_delta):
	$Hurthbox/CollisionShape2D.set_deferred("disabled", true)
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func shoot_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Shoot")
	
func move():
	velocity = move_and_slide(velocity)

func roll_anim_end():
	$Hurthbox/CollisionShape2D.disabled = false
	velocity = velocity * 0.8
	state = MOVE

func attack_anim_end():
	state = MOVE
	
func shoot():
	var slash = Slash.instance()
	get_parent().add_child(slash)
	slash.position = $HitboxPivot.global_position
	slash.rotation = $HitboxPivot.rotation
	slash.set_Knockback(animationTree.get("parameters/Idle/blend_position"))

func _on_Hurthbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
