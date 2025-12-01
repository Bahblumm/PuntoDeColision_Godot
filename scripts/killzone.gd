extends Area2D 

@onready var timer: Timer = $Timer 
@onready var explosion: AudioStreamPlayer = $Explosion

# Provoca la muerte del jugador al contacto con el area de colisión dada al nodo

func _on_body_entered(body: Node2D) -> void: 
	explosion.play()
	print("Has muerto...") 
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1
	
	get_tree().reload_current_scene()
