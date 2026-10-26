extends AnimatedSprite2D
const s = preload("res://audio/sfxs/troopselect.wav")
const ds = preload("res://audio/sfxs/troopdeselect.wav")
@onready var bapak: CharacterBody2D = $".."
@onready var spran: AnimatedSprite2D = $"."
@onready var sel: AnimatedSprite2D = $"../SelectedArrow"

@onready var op1: Control = $"../Options"
@onready var selsound: AudioStreamPlayer = $"../selectortrooop"
var leter: bool = false
var x: float = 0.0
signal bullet_spawn_lin(gradien: float, konstan: int)
signal trailacornot(con: bool)
var op1twn = Tween

func _ready() -> void:
	sel.hide()
	op1.scale = Vector2.ZERO
	spran.play("idle_down")
	leter = false
	Gamemanag.globclosetab.connect(klosteb)
	$"..".buktab.connect(buktab)

func _troop_press() -> void:
	bapak.trpsprwobble(1.25, 0.2)
	if not bapak.ismusuh and bapak.onwalk == false:
		if leter == false:
			#showmenutroop()
			Gamemanag.selectedktp = bapak.get_instance_id()
			return
		elif Gamemanag.selectedktp == bapak.get_instance_id():
			Gamemanag.selectedktp = 0
			return

func newclik() -> void:
	_troop_press()

func showmenutroop():
	op1twn = create_tween()
	bapak.modulate = Color(1, 1, 0.99)
	sel.show()
	op1twn.set_ease(Tween.EASE_OUT)
	op1twn.set_trans(Tween.TRANS_BACK)
	op1twn.tween_property(op1, "scale", Vector2.ONE, 0.2)
	leter = true
	trailacornot.emit(true)
	selsound.stream = s
	selsound.play()
	#if Gamemanag.selectedktp != get_instance_id():
	#	$"../trooclicker".disabled = true
	#else:
	#	$"../trooclicker".disabled = false
	#Gamemanag.hiderestr.emit(false)

func hidemenutroop():
	op1twn = create_tween()
	bapak.modulate = Color(1, 1, 1)
	sel.hide()
	trailacornot.emit(false)
	op1twn.set_ease(Tween.EASE_IN)
	op1twn.set_trans(Tween.TRANS_BACK)
	leter = false
	x = 0
	selsound.stream = ds
	selsound.play()
	op1twn.tween_property(op1, "scale", Vector2.ZERO, 0.2)
	await op1twn.finished

func klosteb(arg: String):
	if Gamemanag.selectedktp != bapak.get_instance_id():
		return
	if arg == "munculkan_opsi":
		showmenutroop()
		Gamemanag.hiderestr.emit(true)
	elif arg == "all":
		hidemenutroop()

func buktab():
	if Gamemanag.selectedktp == bapak.get_instance_id():
		op1twn = create_tween()
		bapak.modulate = Color(1, 1, 1)
		op1twn.set_ease(Tween.EASE_IN)
		op1twn.set_trans(Tween.TRANS_BACK)
		op1twn.tween_property(op1, "scale", Vector2.ZERO, 0.2)
		await op1twn.finished

func internalcol(bekal: int) -> void:
	if bekal == bapak.get_instance_id() and leter == false and bapak.target == null:
		showmenutroop()
	
	elif bekal != bapak.get_instance_id() and leter == true:
		hidemenutroop()
