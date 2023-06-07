extends Control

var life = 3 setget set_life
var max_life = 3 setget set_max_life

onready var barLife = $Life
onready var barDead = $Dead

func set_life(value):
	life = clamp(value, 0, max_life)
	if barLife != null:
		barLife.rect_size.x = life * 15
	
func set_max_life(value):
	max_life = max(value, 1)
	self.life = min(life, max_life)
	if barDead != null:
		barDead.rect_size.x = life * 15
	
func _ready():
	self.max_life = PlayerStats.max_health
	self.life = PlayerStats.health
	var _test = PlayerStats.connect("health_changed", self, "set_life")
	var _test2 =PlayerStats.connect("max_health_changed", self, "set_max_hearths")
