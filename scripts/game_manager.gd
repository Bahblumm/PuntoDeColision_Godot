extends Node

var score = 0
var score_slimes = 0

const MAX_MONEDAS := 33
const MAX_SLIMES := 21


@onready var score_label: Label = $ScoreLabel
@onready var score_label_slimes: Label = $ScoreLabelSlimes
@onready var falta_label: Label = $FaltaLabel

# Se manejan las puntuaciones de la partida y la detención del cronometro

# Nodo declarado como Access as Unique Name para fácil acceso a su variable 
# desde otros nodos con @onready sin necesidad de pegar su ruta completa

# Funciones para puntuar y actualizar labels de puntuaciones
func add_point():
	score += 1
	score_label.text ="Conseguiste " + str(score) + " monedas de 33"
	print(str(score) + " monedas obtenidas")
	_check_if_all_completed()
	
func add_point_slimes():
	score_slimes += 1
	score_label_slimes.text ="Destruiste " + str(score_slimes) + " slimes verdes de 21"
	print(str(score_slimes) + " slimes destruidos")
	_check_if_all_completed()
	
	# funcion para cuando se obtenga la maxima puntuacion
func _check_if_all_completed():
	if score >= MAX_MONEDAS and score_slimes >= MAX_SLIMES:
		# Parar cronómetro en el HUD
		var hud = get_node("/root/Game/HUD")  # Ajusta la ruta
		hud.stop_timer()
		
		# Obtener el tiempo final del HUD
		var tiempo_final = hud.final_time
		
		falta_label.text = "Enhorabuena! Conseguiste todos los puntos en " + tiempo_final 
		
		
		
