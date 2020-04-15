extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Play_Again_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()
