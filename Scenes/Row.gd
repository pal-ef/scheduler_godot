extends PanelContainer

@onready var ID_label: Label = $HBoxContainer/ID
@onready var operation = $HBoxContainer/Operation
@onready var tme = $HBoxContainer/TME
@onready var tl = $HBoxContainer/TL
@onready var tf = $HBoxContainer/TF
@onready var tres = $HBoxContainer/TRES
@onready var tret = $HBoxContainer/TRET
@onready var te = $HBoxContainer/TE
@onready var ts = $HBoxContainer/TS
@onready var resultado = $HBoxContainer/Resultado
@onready var tp = $HBoxContainer/TP

var reference_info: Array[String] 

func set_data(reference) -> void:
	var info: Array[String] = reference.return_info_row_format()
	reference_info = info
	
func _ready():
	ID_label.text = reference_info[0]
	operation.text = reference_info[1]
	tp.text = reference_info[2]
	tme.text = reference_info[3]
	tl.text = reference_info[4]
	tf.text = reference_info[5]
	tres.text = reference_info[6]
	tret.text = reference_info[7]
	ts.text = reference_info[8]
	te.text = reference_info[9]
	resultado.text = reference_info[10]
