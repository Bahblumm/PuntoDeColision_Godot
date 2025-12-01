extends CharacterBody2D

@onready var jump: AudioStreamPlayer = $Jump
@onready var tap: AudioStreamPlayer = $Tap
@onready var camera: Camera2D = $Camera2D

# --- Camara parametros de zoom---
var zoom_speed = 1.5         # Cuánto aumenta/disminuye por pulsación
var zoom_min = Vector2(3.3, 3.3)  # máximo acercamiento
var zoom_max = Vector2(4.9, 4.9)  # máximo alejamiento


# --- Movimiento ---
const SPEED = 90.0
const JUMP_VELOCITY = -290.0  # salto medio-alto
const GRAVITY = 750.0
const COYOTE_TIME = 0.15
const JUMP_BUFFER = 0.15
const FAST_FALL_MULT = 1.4
const LOW_JUMP_MULT = 1.8
const MAX_FALL_SPEED = 800.0

# --- Dash (ligeramente más notable) ---
const DASH_SPEED = 110.0
const DASH_TIME = 0.18

# --- Rebote elástico (ajustado), no se nota en la mayoria de situaciones ---
const BOUNCE_VERTICAL = -300.0
const BOUNCE_HORIZONTAL = 100.0
var has_bounced: bool = false

# --- Nodos ---
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# --- Variables ---
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var dash_timer: float = 0.0
var is_dashing: bool = false
var dash_direction: float = 0.0

# --- Controles de camara ---
func zoom_in(delta):
	var new_zoom = camera.zoom - Vector2(zoom_speed, zoom_speed) * delta
	new_zoom.x = clamp(new_zoom.x, zoom_min.x, zoom_max.x)
	new_zoom.y = clamp(new_zoom.y, zoom_min.y, zoom_max.y)
	camera.zoom = new_zoom
	
func zoom_out(delta):
	var new_zoom = camera.zoom + Vector2(zoom_speed, zoom_speed) * delta
	new_zoom.x = clamp(new_zoom.x, zoom_min.x, zoom_max.x)
	new_zoom.y = clamp(new_zoom.y, zoom_min.y, zoom_max.y)
	camera.zoom = new_zoom
	

func _physics_process(delta: float) -> void:
	
	# --- Timers ---
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER
	else:
		jump_buffer_timer -= delta

	# --- Dash ---
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		if jump_buffer_timer > 0 and not is_on_floor():
		
			is_dashing = true
			dash_timer = DASH_TIME
			dash_direction = -1 if animated_sprite.flip_h else 1
			jump_buffer_timer = 0
			tap.play()

	# --- Movimiento horizontal, con inercia/resbalamiento leve ---
	var direction := Input.get_axis("move_left", "move_right")
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
	else:
		if direction != 0:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * 3.5 * delta)
			animated_sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * 3.5 * delta)

	# --- Gravedad y salto ---
	if not is_on_floor() and not is_dashing:
		velocity.y += GRAVITY * delta
		if Input.is_action_pressed("down"):
			velocity.y += GRAVITY * (FAST_FALL_MULT - 1.0) * delta
	else:
		if not is_dashing:
			velocity.y = move_toward(velocity.y, 0, GRAVITY * delta * 0.2)

	# --- Salto ---
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0
		jump.play()

	# Variable jump height — mantener salto pulsado prolonga un poco
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += GRAVITY * (LOW_JUMP_MULT - 1.0) * delta

	# Limitar caída
	velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)

	# --- Rebote elástico, no se nota en la mayoria de situaciones ---
	if is_on_floor() and not has_bounced:
		if velocity.y > 0:
			velocity.y = BOUNCE_VERTICAL
			has_bounced = true

	if not is_on_floor() and get_last_slide_collision() and not has_bounced:
		var collision: KinematicCollision2D = get_last_slide_collision()
		var normal = collision.get_normal()
		if normal.x != 0:
			velocity.x = -normal.x * BOUNCE_HORIZONTAL
			has_bounced = true

	# Resetear rebote solo si toca suelo y está casi detenido
	if is_on_floor() and abs(velocity.y) < 1.0:
		has_bounced = false

	# --- Animaciones ---
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if is_dashing:
			animated_sprite.play("dash")
		elif velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
			

	# --- Funciones de Camara ---
	if Input.is_action_pressed("zoom_in"):
		zoom_in(delta)
	if Input.is_action_pressed("zoom_out"):
		zoom_out(delta)

	move_and_slide()
