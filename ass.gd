extends RichTextLabel
var rawteks = "lorem ipsum dolor sit amet,[pause=0.3] consectetur [color=yellow]adipiscing elit.[pause=0.6] sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.[pause=0.6] ut enim ad minim veniam,[pause=0.3] quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
@export var typee = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#startdial(0, 0)
	pass

func startdial(dialset: int, dialidx: int):
	var m = 0
	var textlength = rawteks.length()
	var searchparampauseref = "[pause="
	var searchparamcolorref = "[color="
	var clinteks = ""
	var safety = 0
	if typee == 0.0:
			typee = +0.01

	
	while m < textlength:
		safety += 1
		if safety > 1000:
			print("rem ''while'' berhasil")
			break
		if rawteks.substr(m, searchparampauseref.length()) == searchparampauseref:
			var searchidxcloser = rawteks.find("]", m)
			var dur = float(rawteks.substr(m + searchparampauseref.length(), searchidxcloser - (searchparampauseref.length())))
			m += searchparampauseref.length() + rawteks.substr(m + searchparampauseref.length(), searchidxcloser - (m + searchparampauseref.length())).length() + 1
			await get_tree().create_timer(dur).timeout
			continue
		elif rawteks.substr(m, searchparamcolorref.length()) == searchparamcolorref:
			var searchidxcloser = rawteks.find("]", m)
			push_color(rawteks.substr(m + searchparamcolorref.length(), -1 + (searchparampauseref.length())))
			m += searchparamcolorref.length() + rawteks.substr(m + searchparamcolorref.length(), searchidxcloser - (m + searchparamcolorref.length())).length() + 1
			continue
		clinteks = rawteks.substr(m, 1)
		m += 1
		add_text(clinteks)
		await get_tree().create_timer(1.0/typee).timeout
# Called every frame. 'delta' is the elapsed time since the previous frame.
