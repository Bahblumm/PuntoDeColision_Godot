extends Node2D

var is_dead = false

@onready var game_manager: Node = %GameManager
@onready var hurt: AudioStreamPlayer = $Hurt
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone_superior: Area2D = $KillZoneSuperior


func _ready() -> void:
	# Conectar solo la KillZoneSuperior, la que mata al slime verde
	killzone_superior.body_entered.connect(_on_killzone_superior_body_entered)
	

# --- Colisión superior: jugador cae sobre el slime ---
func _on_killzone_superior_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or is_dead:
		return

	is_dead = true

	# Rebote del jugador
	if "velocity" in body:
		body.velocity.y = -250

	# Animación y sonido
	if animated_sprite_2d.sprite_frames.has_animation("death"):
		hurt.play()
		animated_sprite_2d.play("death")

	# Esperar un poco y eliminar el slime y puntuar
	game_manager.add_point_slimes()
	await get_tree().create_timer(0.1).timeout
	queue_free()
