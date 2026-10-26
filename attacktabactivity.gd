extends Control
var instid = null
var currentedit = null
var numram = ""
var flipxy = false

var maxshottr = 0

var gradlin = ""
var constlin = ""

var multiexpo = ""
var growthexpo = ""
var constexpo = ""

var currentbut = null
@export var linabledit: Array = []
@export var expoabledit: Array = []

@onready var exec: Button = $tabarea/executab
@onready var tabcon: Control = $tabarea
@onready var restr: Control = $penghalangklik
@onready var opsitack: HBoxContainer = $tabarea/maintab/attackopts
@onready var attackspec: HBoxContainer = $tabarea/maintab/attackspec
@onready var inputangraph: VBoxContainer = $tabarea/maintab/attackspec/inputangraph
@onready var numpad: Control = $tabarea/maintab/numpad
@onready var xyswapbut: Button = $tabarea/maintab/swapxy
@onready var shotab: Control = $shoott

@onready var gradlinbut: Button = $tabarea/maintab/attackspec/inputangraph/contlinier/gradlin
@onready var constlinbut: Button = $tabarea/maintab/attackspec/inputangraph/contlinier/constlin

@onready var multiexpobut: Button = $tabarea/maintab/attackspec/inputangraph/contexpo/multiexpo
@onready var growthexpobut: Button = $tabarea/maintab/attackspec/inputangraph/contexpo/growthexpo
@onready var constexpobut: Button = $tabarea/maintab/attackspec/inputangraph/contexpo/constexpo

func _ready() -> void:
	exec.disabled = true
	restr.hide()
	tabcon.hide()
	tabcon.position.y = 432.0
	Gamemanag.globtabnimate.connect(tabnimate)
	Gamemanag.doshot.connect(doshot)
	Gamemanag.hiderestr.connect(restrhideornot)
	Gamemanag.hideattab.connect(hideattab)
	attackspec.hide()
	inputangraph.hide()
	opsitack.show()
	numpad.hide()

func restrhideornot(hide: bool):
	if hide:
		restr.hide()
	else:
		restr.show()

func unreview_toggled(toggled_on: bool) -> void:
	var togleable: bool = true
	if toggled_on and togleable == true:
		togleable = false
		var irreview = create_tween()
		irreview.set_ease(Tween.EASE_IN_OUT)
		irreview.set_trans(Tween.TRANS_BACK)
		irreview.tween_property(tabcon, "position:y", 288.0, 0.5)
		await irreview.finished
		togleable = true
	elif toggled_on == false and togleable == true:
		togleable = false
		var review = create_tween()
		review.set_ease(Tween.EASE_IN_OUT)
		review.set_trans(Tween.TRANS_BACK)
		review.tween_property(tabcon, "position:y", 0.0, 0.5)
		await review.finished
		togleable = true

func _on_swapxy_pressed() -> void:
	if Gamemanag.xtoyswap == false:
		xyswapbut.text = "x"
		$tabarea/maintab/attackspec/inputangraph/contlinier/rumusanlinier/samdeng/yylin.text = "x"
		$tabarea/maintab/attackspec/inputangraph/contlinier/xxlin.text = "y"
		$tabarea/maintab/attackspec/inputangraph/contexpo/rumusanexpo/samdeng/yyexpo.text = "x"
		$tabarea/maintab/attackspec/inputangraph/contexpo/xxexpo.text = "y"
		$tabarea/maintab/domianxy/xydom.text = "y"
	else:
		xyswapbut.text = "y"
		$tabarea/maintab/attackspec/inputangraph/contlinier/rumusanlinier/samdeng/yylin.text = "y"
		$tabarea/maintab/attackspec/inputangraph/contlinier/xxlin.text = "x"
		$tabarea/maintab/attackspec/inputangraph/contexpo/rumusanexpo/samdeng/yyexpo.text = "y"
		$tabarea/maintab/attackspec/inputangraph/contexpo/xxexpo.text = "x"
		$tabarea/maintab/domianxy/xydom.text = "x"
	Gamemanag.xtoyswap = not Gamemanag.xtoyswap

func exitprres() -> void:
	Gamemanag.isinedit = false
	$clicksoundtab.play()
	Gamemanag.gridclose.emit(0.0)
	var movtween = create_tween()
	var exx = create_tween()
	exx.set_ease(Tween.EASE_IN)
	exx.set_trans(Tween.TRANS_BACK)
	exx.tween_property(exec, "position:y", 468.0, 0.5)
	movtween.set_ease(Tween.EASE_IN)
	movtween.set_trans(Tween.TRANS_BACK)
	movtween.tween_property(tabcon, "position:y", 432.0, 0.5)
	await movtween.finished
	tabcon.hide()
	Gamemanag.globclosetab.emit("munculkan_opsi")
	numram = ""
	#linear section
	gradlin = ""
	constlin = ""
	multiexpo = ""
	growthexpo = ""
	constexpo = ""
	
	currentedit = null
	
	gradlinbut.button_pressed = false
	constlinbut.button_pressed = false
	gradlinbut.text = "m"
	constlinbut.text = "b"
	
	multiexpobut.button_pressed = false
	growthexpobut.button_pressed = false
	constexpobut.button_pressed = false
	multiexpobut.text = "k"
	growthexpobut.text = "a"
	constexpobut.text = "c"
	
	opsitack.show()
	attackspec.hide()
	inputangraph.hide()
	numpad.hide()

func tabnimate(id_enter: int):
	Gamemanag.isinedit = true
	$tabarea/maintab/unreview.button_pressed = false
	instid = id_enter
	restr.show()
	tabcon.show()
	var movtween = create_tween()
	movtween.set_ease(Tween.EASE_OUT)
	movtween.set_trans(Tween.TRANS_BACK)
	movtween.tween_property(tabcon, "position:y", 0.0, 0.5)

func linearopt() -> void:
	var movtween = create_tween()
	movtween.set_ease(Tween.EASE_IN)
	movtween.set_trans(Tween.TRANS_BACK)
	movtween.tween_property(tabcon, "position:y", 432.0, 0.5)
	await movtween.finished
	currentedit = "linier"
	opsitack.hide()
	attackspec.show()
	inputangraph.show()
	cekanak_inputangraph()
	$tabarea/maintab/attackspec/inputangraph/contlinier.show()
	$tabarea/maintab/attackspec/inputangraph/kets/ket/linierket.show()
	$tabarea/maintab/numpad.show()
	var movtween2 = create_tween()
	movtween2.set_ease(Tween.EASE_OUT)
	movtween2.set_trans(Tween.TRANS_BACK)
	movtween2.tween_property(tabcon, "position:y", 0.0, 0.5)

func expoopt() -> void:
	var movtween = create_tween()
	movtween.set_ease(Tween.EASE_IN)
	movtween.set_trans(Tween.TRANS_BACK)
	movtween.tween_property(tabcon, "position:y", 432.0, 0.5)
	await movtween.finished
	currentedit = "expo"
	opsitack.hide()
	attackspec.show()
	inputangraph.show()
	cekanak_inputangraph()
	$tabarea/maintab/attackspec/inputangraph/contexpo.show()
	$tabarea/maintab/attackspec/inputangraph/kets/ket/expoket.show()
	$tabarea/maintab/numpad.show()
	var movtween2 = create_tween()
	movtween2.set_ease(Tween.EASE_OUT)
	movtween2.set_trans(Tween.TRANS_BACK)
	movtween2.tween_property(tabcon, "position:y", 0.0, 0.5)

func cekanak_inputangraph():
	for anak in inputangraph.get_children():
		if "visible" in anak and anak.name != "kets":
			anak.hide()
	for anak in $tabarea/maintab/attackspec/inputangraph/kets/ket.get_children():
		if "visible" in anak:
			anak.hide()

func updateinput():
	if currentbut != null:
		currentbut.text = str(numram)
		if currentbut == gradlinbut:
			gradlin = numram
		elif currentbut == constlinbut:
			constlin = numram
		elif currentbut == multiexpobut:
			multiexpo = numram
		elif currentbut == growthexpobut:
			growthexpo = numram
		elif currentbut == constexpobut:
			constexpo = numram
		
		if currentedit == "linier" and not gradlin == "" and not constlin == "":
			exec.disabled = false
			tutupexe(351.0, 0.5, "EASE_OUT")
		elif currentedit == "expo" and not multiexpo == "" and not growthexpo == "" and not constexpo == "":
			exec.disabled = false
			tutupexe(351.0, 0.5, "EASE_OUT")
		else:
			exec.disabled = true
			tutupexe(468.0, 0.5, "EASE_IN")
	else:
		return

func tutupexe(posy: float, dur: float, ease: String):
	var exx = create_tween()
	exx.set_trans(Tween.TRANS_BACK)
	if ease == "EASE_OUT":
		exx.set_ease(Tween.EASE_OUT)
	elif ease == "EASE_IN":
		exx.set_ease(Tween.EASE_IN)
	else:
		exx.set_trans(Tween.TRANS_LINEAR)
	exx.tween_property(exec, "position:y", posy, abs(dur))
	await exx.finished
	$shoott/HBoxContainer/bat/sl.visible = false
	$shoott/HBoxContainer/bat/bt.visible = true

#region linearput
func updatelinenabler():
	if linabledit.is_empty():
		currentbut = null
		numram = ""

func gradlin_put(toggled_on: bool) -> void:
	if toggled_on:
		currentbut = gradlinbut
		numram = gradlin
		linabledit.append("m")
		updatelinenabler()
	else:
		linabledit.erase("m")
		updatelinenabler()

func constlin_put(toggled_on: bool) -> void:
	if toggled_on:
		currentbut = constlinbut
		numram = constlin
		linabledit.append("b")
		updatelinenabler()
	else:
		linabledit.erase("b")
		updatelinenabler()

#endregion

#region expoput
func updateexpoenabler():
	if expoabledit.is_empty():
		currentbut = null
		numram = ""

func multiexpo_put(toggled_on: bool) -> void:
	if toggled_on:
		currentbut = multiexpobut
		numram = multiexpo
		expoabledit.append("k")
		updateexpoenabler()
	else:
		expoabledit.erase("k")
		updateexpoenabler()

func growthexpo_put(toggled_on: bool) -> void:
	if toggled_on:
		currentbut = growthexpobut
		numram = growthexpo
		expoabledit.append("a")
		updateexpoenabler()
	else:
		expoabledit.erase("a")
		updateexpoenabler()

func constexpo_put(toggled_on: bool) -> void:
	if toggled_on:
		currentbut = constexpobut
		numram = constexpo
		expoabledit.append("c")
		updateexpoenabler()
	else:
		expoabledit.erase("c")
		updateexpoenabler()

#endregion

#region numput
func inputdigits(value):
	if numram == null:
		numram = ""
	#import char kondisi value = angka
	if value != "." and value != "-" and value != "0":
		if float(numram) == 0.0 and not numram.contains(".") and not numram == "0" and not numram == "-0":
			numram = numram + value
		elif numram == "-":
			numram = "-" + value
		elif not numram == "" and not numram == "0" and not numram == "-0":
			numram = numram + value
		elif numram == "0":
			numram = value
		elif numram == "-0":
			numram = "-" + value
	#import char kondisi value = 0
	elif value == "0":
		if numram == "0" or numram == "-0":
			pass
		else:
			numram = numram + value
	#import char kondisi value = "."
	elif value == ".":
		if not numram.contains("."):
			numram = numram + value
		elif float(numram) == 0.0 and value == "." and numram.contains("."):
			pass
		elif float(numram) == 0.0 and value == "." and not numram.contains("."):
			numram = numram + value
	#import char kondisi value = "-"
	elif value == "-":
		if numram == "-":
			pass
		elif not numram.contains("-") and not numram == "":
			numram = "-" + numram
		elif not numram.contains("-") and numram == "":
			numram = "-" + numram
		elif numram.contains("-"):
			numram = numram.replace("-", "")

	
	var nmpros = numram.replace("-", "")
	if float(nmpros) > 30.0 or nmpros.length() > 4 and float(nmpros) < 10 or nmpros.length() > 5 and float(nmpros) >= 10:
		nmpros = nmpros.left(-1)
		numram = nmpros if not numram.contains("-") else "-" + nmpros
	updateinput()
	#print(float(numram))

func deletedigits() -> void:
	if numram != null:
		numram = numram.left(-1)
	elif numram.length() == 1:
		numram = null
	else:
		return
	updateinput()
	#linsect
	if currentbut == gradlinbut and numram == "":
		currentbut.text = "m"
	elif currentbut == constlinbut and numram == "":
		currentbut.text = "b"
	#exposect
	if currentbut == multiexpobut and numram == "":
		currentbut.text = "m"
	elif currentbut == growthexpobut and numram == "":
		currentbut.text = "g"
	elif currentbut == constexpobut and numram == "":
		currentbut.text = "c"

#region inputs
func buttone() -> void:
	inputdigits("1")
func butttwo() -> void:
	inputdigits("2")
func buttthree() -> void:
	inputdigits("3")
func buttfour() -> void:
	inputdigits("4")
func buttfive() -> void:
	inputdigits("5")
func buttsix() -> void:
	inputdigits("6")
func buttseven() -> void:
	inputdigits("7")
func butteight() -> void:
	inputdigits("8")
func buttnine() -> void:
	inputdigits("9")
func buttzero() -> void:
	inputdigits("0")
func buttkoma() -> void:
	inputdigits(".")
func buttminus() -> void:
	inputdigits("-")
#endregion inputs
#endregion numput

func executebutpress() -> void:
	if currentedit == "linier":
		Gamemanag.calltembaklin.emit(float(gradlin), float(constlin))
	elif currentedit == "expo":
		Gamemanag.calltembakexpo.emit(float(multiexpo), float(growthexpo), float(constexpo))
	#animating current tab ection

func hideattab():
	$clicksoundtab.play()
	var movtween = create_tween()
	var exx = create_tween()
	exx.set_ease(Tween.EASE_IN)
	exx.set_trans(Tween.TRANS_BACK)
	exx.tween_property(exec, "position:y", 468.0, 0.5)
	movtween.set_ease(Tween.EASE_IN)
	movtween.set_trans(Tween.TRANS_BACK)
	movtween.tween_property(tabcon, "position:y", 432.0, 0.5)
	await movtween.finished
	
	#gradlinbut.text = numram if gradlinbut == currentbut else gradlinbut.text
	#constlinbut.text = numram if constlinbut == currentbut else constlin.text
	#multiexpobut.text = numram if multiexpobut == currentbut else multiexpobut.text
	#growthexpobut.text = numram if growthexpobut == currentbut else growthexpobut.text
	#constexpobut.text = numram if constexpobut == currentbut else constexpobut.text
	
	gradlinbut.button_pressed = false
	constlinbut.button_pressed = false
	multiexpobut.button_pressed = false
	growthexpobut.button_pressed = false
	constexpobut.button_pressed = false
	
	

func batalshot() -> void:
	closeshotab()
	maxshottr = 0
	await get_tree().create_timer(0.25).timeout
	if currentedit == "linier":
		linearopt()
		exec.disabled = true
		tutupexe(351.0, 0.5, "EASE_OUT")
	elif currentedit == "expo": # and gradlin != "" and constlin != "":
		expoopt()
		exec.disabled = true
		tutupexe(351.0, 0.5, "EASE_OUT")

func selesaishot() -> void:
	Gamemanag.reven.emit()
	closeshotab()
	await get_tree().create_timer(0.25).timeout
	#region
	maxshottr = 0
	exec.disabled = true
	tutupexe(351.0, 0.5, "EASE_OUT")
	Gamemanag.isinedit = false
	$clicksoundtab.play()
	Gamemanag.gridclose.emit(0.0)
	var movtween = create_tween()
	var exx = create_tween()
	exx.set_ease(Tween.EASE_IN)
	exx.set_trans(Tween.TRANS_BACK)
	exx.tween_property(exec, "position:y", 468.0, 0.5)
	movtween.set_ease(Tween.EASE_IN)
	movtween.set_trans(Tween.TRANS_BACK)
	movtween.tween_property(tabcon, "position:y", 432.0, 0.5)
	await movtween.finished
	tabcon.hide()
	Gamemanag.globclosetab.emit("all")
	numram = ""
	#linear section
	gradlin = ""
	constlin = ""
	multiexpo = ""
	growthexpo = ""
	constexpo = ""
	
	currentedit = null
	
	gradlinbut.button_pressed = false
	constlinbut.button_pressed = false
	gradlinbut.text = "m"
	constlinbut.text = "b"
	
	multiexpobut.button_pressed = false
	growthexpobut.button_pressed = false
	constexpobut.button_pressed = false
	multiexpobut.text = "k"
	growthexpobut.text = "a"
	constexpobut.text = "c"
	#endregion
	restr.hide()
	opsitack.show()
	attackspec.hide()
	inputangraph.hide()
	numpad.hide()

func doshot():
	await get_tree().create_timer(0.25).timeout
	Gamemanag.isinedit = true
	if currentedit == null:
		return
	var movtween2 = create_tween()
	movtween2.set_ease(Tween.EASE_OUT)
	movtween2.set_trans(Tween.TRANS_BACK)
	movtween2.tween_property(shotab, "position:y", 464.0, 0.5)

func closeshotab():
	var movtwee = create_tween()
	movtwee.set_ease(Tween.EASE_IN)
	movtwee.set_trans(Tween.TRANS_BACK)
	movtwee.tween_property(shotab, "position:y", 768.0, 0.5)

func toggle_domain(toggled_on: bool) -> void:
	if toggled_on:
		Gamemanag.firstquad = not Gamemanag.firstquad
	else: 
		Gamemanag.firstquad = not Gamemanag.firstquad


func shott() -> void:
	#print(maxshottr)
	if maxshottr > 2:
		return
	instance_from_id(Gamemanag.selectedktp).lastpos = instance_from_id(Gamemanag.selectedktp).global_position
	maxshottr += 1
	if currentedit == "linier":
		Gamemanag.execlin.emit()
	elif currentedit == "expo":
		Gamemanag.execexpo.emit()
	$shoott/HBoxContainer/bat/sl.show()
	$shoott/HBoxContainer/bat/bt.hide()
