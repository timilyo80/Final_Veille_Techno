extends Area2D

export(String) var level = "world"
export(int) var warpX = 1
export(int) var warpY = 1

var err = false
var permanence = Permanence

func _on_WarpLevel_body_entered(_body):
	permanence.LevelposX = warpX
	permanence.LevelposY = warpY
	err = get_tree().change_scene("res://" + level + ".tscn")
	if err:
		print(err)
