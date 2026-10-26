extends Camera2D

@export var zoom_speed: float = 0.05
@export var min_zoom: float = 4.0
@export var max_zoom: float = 12.0

@export_group("Camera Limits")
@export var limit_left_pos: float = -2000.0
@export var limit_top_pos: float = -2000.0
@export var limit_right_pos: float = 2000.0
@export var limit_bottom_pos: float = 2000.0

# === PENGATURAN RANDOM SWAY ===
@export_group("Camera Sway")
@export var position_sway_amount: float = 15.0 # Maksimal piksel bergeser (offset)
@export var rotation_sway_amount: float = 0.05  # Maksimal radian berputar (sekitar 1.7 derajat)
@export var sway_speed: float = 0.1           # Kecepatan ayunan acak

var target_zoom: float = 1.0
var touch_points: Dictionary = {}
var start_zoom: Vector2
var start_dist: float = 0.0

var noise: FastNoiseLite = FastNoiseLite.new()
var timeacc: float = 0.0

func _ready() -> void:
	target_zoom = zoom.x
	_apply_camera_limits()
	
	noise.seed = randi() 
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5 

func _process(delta: float) -> void:
	timeacc += delta * sway_speed
	
	# Mengambil nilai acak halus dari titik koordinat Y noise yang berbeda 
	# agar gerakan X, Y, dan Rotasi tidak searah/kembar
	var noise_x = noise.get_noise_2d(timeacc, 100.0)
	var noise_y = noise.get_noise_2d(timeacc, 200.0)
	var noise_rot = noise.get_noise_2d(timeacc, 300.0)
	
	# Terapkan sway acak halus langsung pada offset dan rotation visual kamera
	offset.x = noise_x * position_sway_amount
	offset.y = noise_y * position_sway_amount
	rotation = noise_rot * rotation_sway_amount
	
	#$"../dialpoppu".scale = Vector2(1.0/target_zoom * 7.0, 1.0/target_zoom * 7.0)

func _input(event: InputEvent) -> void:
	# --- INPUT UNTUK PC (MOUSE) ---
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				target_zoom = min(target_zoom + (target_zoom * zoom_speed), max_zoom)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				target_zoom = max(target_zoom - (target_zoom * zoom_speed), min_zoom)
			zoom = Vector2(target_zoom, target_zoom)
			_apply_camera_limits()
			
	if event is InputEventMouseMotion:
		# Tambahkan pengecekan untuk memastikan ini adalah MOUSE asli, bukan emulasi dari sentuhan Android
		if event.device != -1: 
			if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)) and touch_points.size() < 2:
				position -= event.relative / zoom
				_apply_camera_limits()

	# --- INPUT UNTUK ANDROID (LAYAR SENTUH) ---
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_points[event.index] = event.position
		else:
			touch_points.erase(event.index)
		
		if touch_points.size() == 2:
			var keys = touch_points.keys()
			start_dist = touch_points[keys[0]].distance_to(touch_points[keys[1]])
			start_zoom = zoom

	if event is InputEventScreenDrag:
		# Update posisi koordinat titik sentuh terbaru agar kalkulasi jarak selalu akurat
		touch_points[event.index] = event.position
		
		if touch_points.size() == 1:
			# Geser kamera sesuai tarikan 1 jari
			position -= event.relative / zoom
			_apply_camera_limits()
		elif touch_points.size() == 2:
			var keys = touch_points.keys()
			var current_dist = touch_points[keys[0]].distance_to(touch_points[keys[1]])
			
			if start_dist > 0:
				var zoom_factor = current_dist / start_dist
				var next_zoom = start_zoom * zoom_factor
				target_zoom = clamp(next_zoom.x, min_zoom, max_zoom)
				zoom = Vector2(target_zoom, target_zoom)
				_apply_camera_limits()


	if event is InputEventScreenTouch:
		if event.pressed:
			touch_points[event.index] = event.position
		else:
			touch_points.erase(event.index)
		
		if touch_points.size() == 2:
			var keys = touch_points.keys()
			start_dist = touch_points[keys[0]].distance_to(touch_points[keys[1]])
			start_zoom = zoom

	if event is InputEventScreenDrag:
		touch_points[event.index] = event.position
		
		if touch_points.size() == 1:
			position -= event.relative / zoom
			_apply_camera_limits()
		elif touch_points.size() == 2:
			var keys = touch_points.keys()
			var current_dist = touch_points[keys[0]].distance_to(touch_points[keys[1]])
			
			if start_dist > 0:
				var zoom_factor = current_dist / start_dist
				var next_zoom = start_zoom * zoom_factor
				target_zoom = clamp(next_zoom.x, min_zoom, max_zoom)
				zoom = Vector2(target_zoom, target_zoom)
				_apply_camera_limits()

func _apply_camera_limits() -> void:
	var viewport_size = get_viewport_rect().size
	
	var screen_half_width = (viewport_size.x / 2.0) / zoom.x
	var screen_half_height = (viewport_size.y / 2.0) / zoom.y
	
	var min_x = limit_left_pos + screen_half_width
	var max_x = limit_right_pos - screen_half_width
	var min_y = limit_top_pos + screen_half_height
	var max_y = limit_bottom_pos - screen_half_height
	
	if min_x > max_x:
		position.x = (limit_left_pos + limit_right_pos) / 2.0
	else:
		position.x = clamp(position.x, min_x, max_x)
		
	if min_y > max_y:
		position.y = (limit_top_pos + limit_bottom_pos) / 2.0
	else:
		position.y = clamp(position.y, min_y, max_y)
