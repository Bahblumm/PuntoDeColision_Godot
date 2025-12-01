extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# La animacion gestiona el sonido al coger la moneda, la desparicion de esta, etc

func _on_body_entered(body: Node2D) -> void:
	
	game_manager.add_point()
	animation_player.play("pickup")
	
	
