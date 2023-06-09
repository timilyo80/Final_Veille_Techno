extends Area2D

var velocity = Vector2(1, 0)
var speed = 300
var Trail = load("res://NewItems/Trail.tscn")

func _physics_process(delta):
	if velocity.y != 0:
		position.y += velocity.y * delta * speed
	else:
		position.x += velocity.x * delta * speed

func _on_Hitbox_area_entered(_area):
	#queue_free()
	pass

func set_Knockback(KB):
	$Hitbox.knockback_vector = KB
	velocity = KB


func _on_ProjSlash_body_entered(body):
	queue_free()

func _on_Timer_timeout():
	var trail = Trail.instance()
	trail.rotation = rotation + PI
	print(rotation)
	var world = get_tree().current_scene
	world.add_child(trail)
	trail.global_position = global_position
