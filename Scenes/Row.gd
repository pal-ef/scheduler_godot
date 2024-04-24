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

var reference_info: Array[String] 

func set_data(reference) -> void:
	var info: Array[String] = reference.return_info_row_format()
	reference_info = info
	
func _ready():
	ID_label.text = reference_info[0]
	operation.text = reference_info[1]
	tme.text = reference_info[2]
	tl.text = reference_info[3]
	tf.text = reference_info[4]
	tres.text = reference_info[5]
	tret.text = reference_info[6]
	ts.text = reference_info[7]
	te.text = reference_info[8]
	resultado.text = reference_info[9]
