extends Line2D
var switch: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if switch == true:
		add_point(get_parent().global_position)
		if points.size() > 80:
			remove_point(0)
func _ready() -> void:
	$"../../../TroopSprite".trailacornot.connect(trail)
	
func trail(con: bool):
	if con == false:
		clear_points()
	switch = con
