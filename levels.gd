extends Node2D
@export var map_size = Vector2.ZERO

func _ready() -> void:
	Gamemanag.currentmapsize = map_size
	Gamemanag.vh.connect(vher)

func vher(gotsome: bool):
	var gga = get_node_or_null("hitboxess")
	if gga != null:
		get_node("hitboxess").visible = false if gotsome == false else true
