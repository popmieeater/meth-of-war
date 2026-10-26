extends Control

func _ready() -> void:
	$vhh.button_pressed = true
	Gamemanag.vh.emit(true)
func vhtog(toggled_on: bool) -> void:
	Gamemanag.vh.emit(not toggled_on)
