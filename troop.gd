class_name kelasterup
extends CharacterBody2D
var lastfacing = "side"
var lastpos = Vector2.ZERO
@export var ismusuh: bool = false
var waitingforrev: bool = false

var shotabletter = false

const supido = 56.0
var dutaa = 0.0
var onwalk = false
var currenthelder = ""

var selidikiopen: bool = false
var walkletter: bool = false

@export var target: Node2D = null
@onready var navi := $navier

@onready var spr: CharacterBody2D = self
@onready var trpspr: AnimatedSprite2D = $TroopSprite
@onready var tabtack: Control = $tabarea
@onready var hpin: ColorRect = $TroopHP/HPIndicator
@onready var hpall: Node2D = $TroopHP
@onready var shad: Sprite2D = $Shadow
@onready var dw: Area2D = $detectwall

var lintemhandler = Vector2.ZERO
var expotemhandler = Vector2.ZERO
var linlettershot: bool = false
var expolettershot: bool = false

signal buktab()

var hp = 3:
	set(hpv):
		hp = clamp(hpv, 0, 3)
		#print(hp)
		hpupdater(hpv)
		if hp == 0:
			$collider.queue_free()
			#if not ismusuh:
			#$deathsound.play()
			trpspr.hide()
			var fadedie = create_tween()
			fadedie.set_trans(Tween.TRANS_BACK)
			fadedie.set_ease(Tween.EASE_IN)
			fadedie.tween_property(trpspr, "scale", Vector2.ZERO, 0.05)
			if ismusuh:
				$DIEENEMY.emitting = true
				$deathsound.play()
			else:
				$DIE.emitting = true
				$deathsound.play()
			fadedie.set_trans(Tween.TRANS_BOUNCE)
			fadedie.set_ease(Tween.EASE_OUT)
			fadedie.tween_property(hpall, "position:y", 0.0, 0.75)
			fadedie.tween_property(shad, "modulate:a", 0.0, 0.3)
			fadedie.set_trans(Tween.TRANS_EXPO)
			fadedie.set_ease(Tween.EASE_IN)
			fadedie.tween_property(spr, "modulate:a", 0.0, 1.5)
			await fadedie.finished
			queue_free()

func _ready() -> void:
	Gamemanag.totalallyhp += hp if not ismusuh else 0
	Gamemanag.totalenemyhp += hp if ismusuh else 0
	Gamemanag.totalallyhppercent += hp if not ismusuh else 0
	Gamemanag.totalenemyhppercent += hp if ismusuh else 0
	if not ismusuh: Gamemanag.troopallyquan.append(get_instance_id())
	if ismusuh: Gamemanag.troopenemyquan.append(get_instance_id())
	
	set_physics_process(false)
	call_deferred("jal_setup")
	bullshitdetector()
	Gamemanag.calltembaklin.connect(_receive_bullet_lin)
	Gamemanag.calltembakexpo.connect(_receive_bullet_expo)
	Gamemanag.globclosetab.connect(klosteb)
	Gamemanag.execlin.connect(execlin)
	Gamemanag.execexpo.connect(execexpo)
	playidle()
	
	lastpos = global_position
	
	if ismusuh:
		trpspr.scale.x = -1.0
	else:
		trpspr.scale.x = 1.0
	

#region navig
func jal_setup():
	await get_tree().physics_frame
	if target:
		navi.target_position = target.global_position
		set_physics_process(true)
	else:
		set_physics_process(false)

func playidle():
	await get_tree().create_timer(randf_range(0.0, 0.6)).timeout
	trpspr.play("idle_" + lastfacing)

func _physics_process(delta: float) -> void:
	Gamemanag.hiderestr.emit(false)
	if navi.is_navigation_finished():
		trpspr.play("idle_" + lastfacing)
		$"../navimaptroop".bake_navigation_polygon()
		$"../navimaptankie".bake_navigation_polygon()
		onwalk = false
		target = null
		
		var twon = create_tween()
		if Gamemanag.isinedit == true:
			twon.tween_property(self, "global_position", round(global_position/16) * 16, 0.05)
		else:
			twon.tween_property(self, "global_position", lastpos, 0.05)
	#if currenthelder == "lin":
		#if Gamemanag.xtoyswap == false:
			#global_position = lastpos + Vector2(0.0, -lintemhandler.y) * 16
		#else:
			#global_position = lastpos + Vector2(lintemhandler.y, 0.0) * 16
	#elif currenthelder == "expo":
		#if Gamemanag.xtoyswap == false:
			#global_position = lastpos + Vector2(0.0, -expotemhandler.y) * 16
		#else:
			#global_position = lastpos + Vector2(expotemhandler.y, 0.0) * 16

		if ismusuh:
			trpspr.scale.x = -1.0
		else:
			trpspr.scale.x = 1.0
		set_physics_process(false)
		$naviblok.affect_navigation_mesh = true
		linlettershot = false
		if Gamemanag.isinedit == false:
			trpspr.showmenutroop()
			Gamemanag.hiderestr.emit(true)
		Gamemanag.doshot.emit()
		return
	
	var curagnavipos = global_position
	var nextpathpos = navi.get_next_path_position()
	var new_velocity = curagnavipos.direction_to(nextpathpos) * supido
	
	var angelrun = rad_to_deg(velocity.angle())
	
	if angelrun < 0:
		angelrun += 360.0
	
	if velocity.length() > 2.0:
		dutaa += delta
		onwalk = true
		if dutaa > 0.25:
			$sootfteps.play()
			dutaa = 0.0
		if angelrun >= 0 and angelrun < 22.5 or angelrun >= 337.5 and angelrun < 360.0:
			lastfacing = "side"
			trpspr.scale.x = 1.0
		elif angelrun >= 22.5 and angelrun < 67.5:
			lastfacing = "down_side"
			trpspr.scale.x = 1.0
		elif angelrun >= 67.5 and angelrun < 112.5:
			lastfacing = "down"
			trpspr.scale.x = 1.0
		elif angelrun >= 112.5 and angelrun < 157.5:
			lastfacing = "down_side"
			trpspr.scale.x = -1.0
		elif angelrun >= 157.5 and angelrun <= 202.5:
			lastfacing = "side"
			trpspr.scale.x = -1.0
		elif angelrun >= 202.5 and angelrun <= 247.5:
			lastfacing = "up_side"
			trpspr.scale.x = -1.0
		elif angelrun >= 247.5 and angelrun <= 292.5:
			lastfacing = "up"
			trpspr.scale.x = 1.0
		elif angelrun >= 292.5 and angelrun <= 337.5:
			lastfacing = "up_side"
			trpspr.scale.x = 1.0
		
		trpspr.play("run_" + lastfacing)
		#print(velocity)
	else:
		trpspr.play("idle_" + lastfacing)
		onwalk = false
	
	if navi.avoidance_enabled:
		navi.set_velocity(new_velocity)
	else:
		velocity_computed(new_velocity)
	
	
	move_and_slide()

func velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

#endregion navig

func bullshitdetector():
	if trpspr.material:
		trpspr.material = trpspr.material.duplicate()
	if ismusuh:
		trpspr.use_parent_material = false
		hpin.color = Color("ac3232")
	else:
		trpspr.use_parent_material = true
		hpin.color = Color("8f974a")

var projlintroop= preload("res://projectiles_bullet.tscn")

func trpsprwobble(intensity: float, time: float):
	var wob2 = create_tween()
	var wob = create_tween()
	if not hp == 0:
		var scalenow = -1.0 if trpspr.scale.x < 0.0 else 1.0
		wob.set_ease(Tween.EASE_OUT)
		wob.set_trans(Tween.TRANS_BACK)
		wob.tween_property(trpspr, "scale", Vector2(scalenow * intensity, 1/intensity), time/2)
		wob2.set_ease(Tween.EASE_OUT)
		wob2.set_trans(Tween.TRANS_ELASTIC)
		wob.tween_property(trpspr, "scale", Vector2(scalenow, 1.0), time)

func _on_serang_pressed() -> void:
	Gamemanag.globtabnimate.emit(spr.get_instance_id())
	Gamemanag.gridopen.emit(global_position.x, global_position.y, 1.0)
	buktab.emit()
	trpspr.play("antishot_" + lastfacing)

func klosteb(arg: String):
	if arg != "pindah" or arg != "all":
		return
	if Gamemanag.selectedktp != get_instance_id():
		return
	target = $"../targetter"
	target.global_position = lastpos
	navi.target_position = target.global_position
	set_physics_process(false)
	call_deferred("jal_setup")

func gothurt(damage: int) -> void:
	spr.hp -= damage
	Gamemanag.totalallyhp -= damage if not ismusuh else 0
	Gamemanag.totalenemyhp -= damage if ismusuh else 0
	trpsprwobble(1.5, 0.3)
	var flashdis = create_tween()
	flashdis.tween_callback(turnoffshader)
	flashdis.tween_property(trpspr, "modulate", Color(10, 10, 10), 0)
	flashdis.tween_interval(damage/10.0)
	flashdis.tween_callback(shaderkelapkelipmusuh)
	flashdis.tween_property(trpspr, "modulate", Color(1, 1, 1), 0)
	flashdis.tween_interval(damage/10.0)
	flashdis.tween_property(trpspr, "modulate", Color(10, 10, 10), 0)
	flashdis.tween_callback(turnoffshader)
	flashdis.tween_interval(damage/10.0)
	flashdis.tween_callback(shaderkelapkelipmusuh)
	flashdis.tween_property(trpspr, "modulate", Color(1, 1, 1), 0)

func shaderkelapkelipmusuh():
	if ismusuh:
		trpspr.use_parent_material = false
	else:
		trpspr.use_parent_material = true
func turnoffshader():
	trpspr.use_parent_material = true

func hpupdater(hpv: int) -> void:
	hpin.size.x = hpv * 3

func detekwol(body: Node2D) -> void:
	#print(str(body))
	if selidikiopen == true:
		if body and body.get_instance_id() != Gamemanag.selectedktp:
			dw.global_position = global_position
			selidikiopen = false
			walkletter = false
			Gamemanag.erormessage.emit()

func walkerwhite():
	await get_tree().create_timer(0.05).timeout #snitching detekwol kalau detekwol tidak deteksi apa apa
	if walkletter == false:
		return #snitched
	if dw.global_position.x <= 0.0 or dw.global_position.y <= 0.0 or dw.global_position.x >= Gamemanag.currentmapsize.x * 16.0 or dw.global_position.y >= Gamemanag.currentmapsize.x * 16.0:
		dw.global_position = global_position
		selidikiopen = false
		walkletter = false
		Gamemanag.erormessage.emit()
		return
	Gamemanag.hideattab.emit()
	$naviblok.affect_navigation_mesh = false
	target = $"../targetter"
	target.global_position = dw.global_position
	navi.target_position = target.global_position
	dw.position = Vector2.ZERO
	set_physics_process(false)
	call_deferred("jal_setup")
	selidikiopen = false

#----------Bullet Section----------#
func _receive_bullet_lin(gradien: float, konstan: float) -> void:
	if Gamemanag.selectedktp != get_instance_id():
		return
	currenthelder = "lin"
	if Gamemanag.xtoyswap == false:
		selidikiopen = true
		walkletter = true
		walkerwhite()
		dw.global_position = Vector2(lastpos.x, lastpos.y + (-16.0 * konstan))
		lintemhandler = Vector2(gradien, konstan)
	else:
		selidikiopen = true
		walkletter = true
		walkerwhite()
		dw.global_position = Vector2(lastpos.x + (16.0 * konstan), lastpos.y)
		lintemhandler = Vector2(gradien, konstan)
	linlettershot = true
func execlin():
	if linlettershot == true:
		if currenthelder == "lin":
			pass
		else:
			return
	if spr.get_instance_id() != Gamemanag.selectedktp:
		return
	var bul = projlintroop.instantiate()
	bul.bulletnameholder = spr.get_instance_id()
	bul.bulletlin(float(lintemhandler.x), 0.0, ismusuh)
	bul.global_position = spr.global_position
	
	get_tree().get_current_scene().add_child(bul)
	$attckclick.play()
	angleanim("lin", lintemhandler.x)
	trpsprwobble(1.25, 0.3)
	linlettershot = false

func _receive_bullet_expo(mul: float, gro: float, con: float) -> void:
	if Gamemanag.selectedktp != get_instance_id():
		return
	currenthelder = "expo"
	if Gamemanag.xtoyswap == false:
		selidikiopen = true
		walkletter = true
		walkerwhite()
		dw.global_position = Vector2(lastpos.x, lastpos.y + (-16.0 * mul + -16.0 * con))
		expotemhandler = Vector2(mul, gro)
	else:
		selidikiopen = true
		walkletter = true
		walkerwhite()
		dw.global_position = Vector2(lastpos.x + (16.0 * mul + 16.0 * con), lastpos.y)
		expotemhandler = Vector2(mul, gro)
	expolettershot = true
func execexpo():
	if expolettershot == true:
		if currenthelder == "expo":
			pass
		else:
			return
	if spr.get_instance_id() != Gamemanag.selectedktp:
		return
	var bul = projlintroop.instantiate()
	bul.bulletnameholder = spr.get_instance_id()
	bul.bulletexpo(float(expotemhandler.x), float(expotemhandler.y), 0.0, ismusuh)
	bul.global_position = spr.global_position
	
	get_tree().get_current_scene().add_child(bul)
	$attckclick.play()
	if not expotemhandler.y * expotemhandler.x < 0.3:
		angleanim("lin", expotemhandler.x * expotemhandler.y - expotemhandler.x)
	else:
		angleanim("lin", -100.0)
	#elif expotemhandler.y * expotemhandler.x >= 2.0 and expotemhandler.y * expotemhandler.x < 5.0:
	#	angleanim("lin", 1.0)
	#elif expotemhandler.y * expotemhandler.x >= 1.0 and expotemhandler.y * expotemhandler.x < 2.0:
	#	angleanim("lin", 0.0)
	trpsprwobble(1.25, 0.3)
	expolettershot = false

func angleanim(graph: String, angler: float):
	var angel = 0.0
	if Gamemanag.xtoyswap == false:
		if Gamemanag.firstquad == true:
			angel = round(rad_to_deg(Vector2(1.0, angler).angle()))
		else:
			angel = round(rad_to_deg(Vector2(-1.0, -angler).angle()))
	else:
		if Gamemanag.firstquad == true:
			angel = round(rad_to_deg(Vector2(angler, 1.0).angle()))
		else:
			angel = round(rad_to_deg(Vector2(-angler, -1.0).angle()))
	
	#if angel <= -180:
	#	angel += 180.0
	print(angel)
	if angel >= -22.5 and angel <= 22.5:
		lastfacing = "side"
		trpspr.scale.x = 1.0
	elif angel >= -67.5 and angel <= -22.5:
		lastfacing = "down_side"
		trpspr.scale.x = 1.0
	elif angel >= -112.5 and angel <= -67.5:
		lastfacing = "down"
		trpspr.scale.x = 1.0
	elif angel >= -157.5 and angel <= -112.5:
		lastfacing = "down_side"
		trpspr.scale.x = -1.0
	elif (angel >= -180.0 and angel <= -157.5) or (angel <= 180.0 and angel >= 157.5):
		lastfacing = "side"
		trpspr.scale.x = -1.0
	elif angel >= 112.5 and angel <= 157.5:
		lastfacing = "up_side"
		trpspr.scale.x = -1.0
	elif angel >= 67.5 and angel <= 112.5:
		lastfacing = "up"
		trpspr.scale.x = 1.0
	elif angel >= 22.5 and angel <= 67.5:
		lastfacing = "up_side"
		trpspr.scale.x = 1.0
	
	trpspr.play("shot_" + lastfacing)
	await get_tree().create_timer(0.3).timeout
	trpspr.play("antishot_" + lastfacing)

func angleanimrev(angler: Vector2):
	var angel = 0.0
	angel = round(rad_to_deg(angler.angle()))
	print(str(angel) + " u are my angel teddy")
	if angel >= -22.5 and angel <= 22.5:
		lastfacing = "side"
		trpspr.scale.x = 1.0
	elif angel >= -67.5 and angel <= -22.5:
		lastfacing = "up_side"
		trpspr.scale.x = 1.0
	elif angel >= -112.5 and angel <= -67.5:
		lastfacing = "up"
		trpspr.scale.x = 1.0
	elif angel >= -157.5 and angel <= -112.5:
		lastfacing = "up_side"
		trpspr.scale.x = -1.0
	elif (angel >= -180.0 and angel <= -157.5) or (angel <= 180.0 and angel >= 157.5):
		lastfacing = "side"
		trpspr.scale.x = -1.0
	elif angel >= 112.5 and angel <= 157.5:
		lastfacing = "down_side"
		trpspr.scale.x = -1.0
	elif angel >= 67.5 and angel <= 112.5:
		lastfacing = "down"
		trpspr.scale.x = 1.0
	elif angel >= 22.5 and angel <= 67.5:
		lastfacing = "down_side"
		trpspr.scale.x = 1.0
	
	trpspr.play("shot_" + lastfacing)
	await get_tree().create_timer(0.3).timeout
	trpspr.play("antishot_" + lastfacing)

func friendsh(shootertrop):
	if waitingforrev or hp == 0:
		return
	waitingforrev = true
	var tropfromid = instance_from_id(shootertrop)
	if ismusuh == true or not is_instance_valid(tropfromid):
		return
	await Gamemanag.reven
	if hp == 0:
		waitingforrev = false
		return
	var bul = projlintroop.instantiate()
	bul.bulletnameholder = spr.get_instance_id()
	bul.bulletrev(tropfromid.global_position/16 - spr.global_position/16, true, get_instance_id())
	bul.global_position = spr.global_position
	
	get_tree().get_current_scene().add_child(bul)
	$attckclick.play()
	angleanimrev(tropfromid.global_position - spr.global_position) #2rev
	trpsprwobble(1.25, 0.3)
	waitingforrev = false
	await get_tree().create_timer(2.0).timeout
	trpspr.play("idle_" + lastfacing)
