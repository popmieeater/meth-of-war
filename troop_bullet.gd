extends CharacterBody2D

class_name Bullet

var deltspeed = 0.0
var startpos = Vector2.ZERO

var jenisgraph: String = ""
var bulletnameholder = null
var bulletmalevolent: bool = false
const SPEED = 300.0
var grad: float = 0.0
var multi: float = 0.0
var growth: float = 0.0
var gradarah = Vector2.ZERO 
var konst: float = 0.0
var leter: bool = false
var expoiteration = 0.0
var exponot = Vector2.ZERO
var rev = Vector2.ZERO

var fristqud = 1

@onready var bul: Sprite2D = $Bullet
@onready var bulef: CPUParticles2D = $Bullet/bulpar
@onready var bulimp: CPUParticles2D = $Bullet/shootimpactpar
@onready var spr: AnimatedSprite2D = $"../TroopSprite"

func _physics_process(delta: float) -> void:
	expoiteration += delta * SPEED / 0.1
	
	if jenisgraph == "lin":
		if Gamemanag.xtoyswap == false:
			gradarah = Vector2(1.0, grad).normalized()
		else:
			gradarah = Vector2(grad, 1.0).normalized()
	
	elif jenisgraph == "expo":
		if Gamemanag.xtoyswap == false:
			var xcurrent = floor((global_position.x - startpos.x) / 4.0)
			
			var yse = -multi * (pow(growth, xcurrent / 4.0) - 1.0) * 16.0
			var yni = -multi * (pow(growth, (xcurrent + 1.0) / 4.0) - 1.0) * 16.0
			var deltay = yni - yse
			
			gradarah = Vector2(4.0, deltay).normalized()
		else:
			var ycurrent = floor((global_position.y - startpos.y) / 4.0)
			
			var xse = multi * (pow(growth, ycurrent / 4.0) - 1.0) * 16.0
			var xni = multi * (pow(growth, (ycurrent + 1.0) / 4.0) - 1.0) * 16.0
			var deltax = xni - xse
			
			gradarah = Vector2(deltax, 4.0).normalized()
	
	elif jenisgraph == "rev":
		gradarah = rev
		#print(str(gradarah) + "ini gradarah woi")
	
	if not jenisgraph == "rev":
		velocity = gradarah * SPEED * fristqud
	else:
		velocity = gradarah * SPEED
	
	move_and_slide()
	
	if is_on_wall() or is_on_floor() or is_on_ceiling():
		reset_peluru("wall")
		print("auhh bunda teddy")


func _ready() -> void:
	startpos = global_position

func cekfriskud():
	if Gamemanag.firstquad == true and Gamemanag.xtoyswap == false:
			fristqud = 1
	elif Gamemanag.firstquad == false and Gamemanag.xtoyswap == false:
		fristqud = -1
	elif Gamemanag.firstquad == true and Gamemanag.xtoyswap == true:
			fristqud = -1
	elif Gamemanag.firstquad == false and Gamemanag.xtoyswap == true:
		fristqud = 1

func bulletlin(gradien: float, konstan: float, musuh: bool) -> void:
	cekfriskud()
	jenisgraph = "lin"
	bulletmalevolent = musuh
	if bul == null:
		bul = get_node("Bullet")
	if bulef == null:
		bulef = get_node("Bullet/bulpar")
	if bulimp == null:
		bulimp = get_node("Bullet/shootimpactpar")
	#if $".".get_instance_id() != Gamemanag.selectedktp:
		#return
	bulletnameholder = Gamemanag.selectedktp
	self.global_position = instance_from_id(Gamemanag.selectedktp).global_position
	
	grad = gradien  * -1.0
	konst = konstan * -1.0
	
	if Gamemanag.xtoyswap == false:
		rotation = Vector2(1.0, grad).angle()
	else:
		rotation = Vector2(grad, 1.0).angle()
	
	scale = Vector2(fristqud, fristqud)
	
	bul.scale = Vector2.ONE
	bul.self_modulate.a = 1.0 
	
	#set velocity awal jadi zero untuk reset fisika
	velocity = Vector2.ZERO
	exephysics.call_deferred() #deferred untuk apa? untuk menunda memberi sifat fisika ke bullet sebelum posisi diubah constyadder
	#call_deferred() ibarat wait 0 second di scratch

func bulletexpo(mul: float, grow: float, kon: float, musuh: bool) -> void:
	cekfriskud()
	jenisgraph = "expo"
	bulletmalevolent = musuh
	if bul == null:
		bul = get_node("Bullet")
	if bulef == null:
		bulef = get_node("Bullet/bulpar")
	if bulimp == null:
		bulimp = get_node("Bullet/shootimpactpar")
	
	jenisgraph = "expo"
	multi = mul
	growth = grow
	
	scale = Vector2(fristqud, fristqud)
	
	bul.scale = Vector2.ONE
	bul.self_modulate.a = 1.0 
	
	#set velocity awal jadi zero untuk reset fisika
	velocity = Vector2.ZERO
	exephysics.call_deferred()

func exephysics() -> void:
	force_update_transform()
	leter = true
	set_physics_process(true)

func bulletrev(allypos: Vector2, musuh: bool, kiminonawwa: int) -> void: #3rev
	print(str(allypos) + "anji")
	jenisgraph = "rev"
	bulletmalevolent = true
	if bul == null:
		bul = get_node("Bullet")
	if bulef == null:
		bulef = get_node("Bullet/bulpar")
	if bulimp == null:
		bulimp = get_node("Bullet/shootimpactpar")
	#if $".".get_instance_id() != Gamemanag.selectedktp:
		#return
	bulletnameholder = kiminonawwa
	self.global_position = instance_from_id(bulletnameholder).global_position
	
	rev = allypos.normalized()
	
	rotation = allypos.angle()
	
	bul.scale = Vector2.ONE
	bul.self_modulate.a = 1.0 
	
	#set velocity awal jadi zero untuk reset fisika
	velocity = Vector2.ZERO
	#exephysics.call_deferred() 
	leter = true
	set_physics_process(true)
	print(str(rev.normalized())+ "anjjay")

func _constyadder(ko):
	if Gamemanag.xtoyswap == false:
		global_position.y += (-ko * 16)
	else:
		global_position.x += (ko * 16)

func reset_peluru(gotdam: String):
	$bulletarea.queue_free()
	$Bulletcollwall.queue_free()
	set_physics_process(false)
	if gotdam == "trp":
		$hithuman.play()
	elif gotdam == "wall":
		$hitstone.play()
		bulimp.emitting = true
	velocity = Vector2.ZERO
	leter = false
	bul.self_modulate.a = 0.0
	bulef.emitting = false
	bulletnameholder = null
	await $Bullet/bulpar.finished
	queue_free()


func hurtthetroop(body: Node2D) -> void:
	if body is kelasterup and body.has_method("gothurt"):
		if str(body.get_instance_id()) != str(bulletnameholder):
			if "hp" in body and body.hp != 0:
				body.gothurt(1)
				reset_peluru("trp")
		#friendly_fire
		if not bulletmalevolent and body.has_method("friendsh") and body.hp > 0 and Gamemanag.totalallyhp * 100 / Gamemanag.totalallyhppercent >= 50.0:
			await get_tree().create_timer(0.5).timeout
			body.friendsh(Gamemanag.selectedktp) #1rev
			
