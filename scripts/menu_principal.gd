extends Control

# Variables llamadas al arrancar
@onready var label_2: Label = $CenterContainer/VBoxContainer/Label2
@onready var label_3: Label = $CenterContainer/VBoxContainer/Label3


func _ready() -> void:
	# Asegura que el juego vuelva a velocidad normal
	Engine.time_scale = 1.0
	
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
