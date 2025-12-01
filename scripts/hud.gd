extends CanvasLayer

# Controla la UI fija en pantalla, que es el botón de menú principal 
# y el cronometro

@onready var label_timer: Label = $LabelTimer
@onready var button_menu: Button = $ButtonMenu

var elapsed_time: float = 0.0
var running: bool = false
var final_time := ""

func _ready():
	# Se inicia el cronometro con el inicio de la escena del juego
	start_timer()
	# Conectamos la señal pressed del botón al método del HUD
	button_menu.pressed.connect(_on_ButtonMenu_pressed)
	

# Función que se ejecuta al pulsar el botón
func _on_ButtonMenu_pressed():
	# Cambia la escena al menú principal
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")
	
# Flujo del cronometro 
func _process(delta: float):
	if running:
		elapsed_time += delta
		update_label()
	
# Funciones de manejo del cronometro
func start_timer():
	elapsed_time = 0.0
	running = true

func stop_timer():
	running = false
	final_time = label_timer.text
	
func update_label():
	# Formato mm:ss.cs (minutos:segundos:centésimas)
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	var centi   = int((elapsed_time - int(elapsed_time)) * 100)
	label_timer.text = "%02d:%02d:%02d" % [minutes, seconds, centi]
