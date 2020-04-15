extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Give_Up_pressed():
	get_tree().quit()

func _on_Try_Again_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")
