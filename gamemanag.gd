extends Node
var xtoyswap = false
var firstquad = true
var isinedit = false
@onready var prajurit = $Troop
@onready var menu_ui = $AttackTabActivity

var troopallyquan = []
var troopenemyquan = []
var totalallyhp = 0
var totalallyhppercent = 0
var totalenemyhp = 0
var totalenemyhppercent = 0
var currentmapsize = Vector2.ZERO

@export var selectedktp: int = 0:
	set(value):
		selectedktp = value
		print(value)
		get_tree().call_group("troop_group", "internalcol", selectedktp)

signal globtabnimate(instid: int)
signal globclosetab(arg: String)
signal gridopen(posx: float, posy: float, fade: float)
signal gridclose(fade: float)
signal erormessage()
signal vh(boolhit: bool)
signal doshot()
signal hiderestr(hide: bool)
signal hideattab()
signal reven()

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	print("Allies Total HP: " + str(totalallyhp) + ", Enemies Total HP: " + str(totalenemyhp) + ". Allies Quantity: " + str(troopallyquan.size()) + ", Enemies Quantity: " + str(troopenemyquan.size()))

signal calltembaklin(grad: float, konst: float)
signal calltembakexpo(multi: float, growth: float, konst: float)

signal execlin()
signal execexpo()

func com():
	pass
