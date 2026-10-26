extends Node2D

func _ready() -> void:
	modulate.a = 0.0
	Gamemanag.gridopen.connect(greedopen)
	Gamemanag.gridclose.connect(greedclose)



func greedopen(posx: float, posy: float, fade: float):
	var gridtwn = create_tween()
	position = Vector2(round(posx/16) * 16, round(posy/16) * 16)
	gridtwn.tween_property(self, "modulate:a", fade, 0.25)

func greedclose(fade: float):
	var gridtwn = create_tween()
	gridtwn.tween_property(self, "modulate:a", fade, 0.25)
