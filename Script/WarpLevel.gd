extends Area2D

export(String) var level = "world"

var err = false

func _on_WarpLevel_body_entered(_body):
	err = get_tree().change_scene("res://" + level + ".tscn")
	if err:
		print(err)
