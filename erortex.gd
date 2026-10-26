extends RichTextLabel
@onready var tex: Control = $".."
var tw: Tween = null

func _ready() -> void:
	Gamemanag.erormessage.connect(animadora)
# Called when the node enters the scene tree for the first time.
func animadora():
	tw = create_tween()
	tw.set_ease(Tween.EASE_OUT)
	tw.set_trans(Tween.TRANS_BACK)
	tw.tween_property(tex, "position:y", 160.0, 0.25)
	$"../rorchord".play()
	tw.tween_interval(2.5)
	tw.set_ease(Tween.EASE_IN)
	tw.set_trans(Tween.TRANS_BACK)
	tw.tween_property(tex, "position:y", 0.0, 0.25)
