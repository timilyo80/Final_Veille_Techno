extends Area2D

var velocity = Vector2(1, 0)
var speed = 300

func _physics_process(delta):
	position.x += velocity.x * delta * speed
	position.y += velocity.y * delta * speed

func _on_Hitbox_area_entered(_area):
	#queue_free()
	pass

func set_Knockback(KB):
	$Hitbox.knockback_vector = KB
	velocity = KB


func _on_ProjSlash_body_entered(body):
	queue_free()
