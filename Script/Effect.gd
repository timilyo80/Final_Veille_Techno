extends AnimatedSprite

func _ready():
	var _test = self.connect("animation_finished", self, "_on_animation_finished")
	play("Hit")

func _on_animation_finished():
	queue_free()
