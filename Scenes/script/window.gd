extends Control

@onready var numberOfProcessesLabel = $PanelContainer/ColorRect/CenterContainer/Panel/MarginContainer/VBoxContainer/NumberInput/Label
@onready var sfx = $SFX
@export var numberOfProcesses: int = 5
@onready var quantumNumberLabel = $PanelContainer/ColorRect/CenterContainer/Panel/MarginContainer/VBoxContainer/NumberInput2/Label

var quantum: int = 3

var parent
var child

const ROLLOVER_2 = preload("res://Assets/Bonus/rollover2.ogg")
const SWITCH_2 = preload("res://Assets/Bonus/switch2.ogg")
func _ready() -> void:
	sfx.stream = ROLLOVER_2
	update_numberOfProcessesLabel()

func update_numberOfProcessesLabel():
	numberOfProcessesLabel.text = str(numberOfProcesses)

func _on_texture_button_button_up():
	numberOfProcesses += 1
	update_numberOfProcessesLabel()
	sfx.play()

func _on_texture_button_2_button_up():
	numberOfProcesses -= 1
	if numberOfProcesses < 0:
		numberOfProcesses = 0
	else:
		update_numberOfProcessesLabel()
		sfx.play()

func add_child_to_parent_when_start(_parent, _child):
	parent = _parent
	child = _child

# Confirmation button
func _on_button_button_up():
	GlobalManager.set_number_of_processes(numberOfProcesses)
	GlobalManager.set_quantum(quantum)
	GlobalManager.populate()
	sfx.stream = SWITCH_2
	sfx.play()
	parent.add_child(child)
	visible = false
	
func _on_sfx_finished():
	if sfx.stream == SWITCH_2:
		queue_free()

func update_quantum_label() -> void:
	quantumNumberLabel.text = str(quantum)

func _on_quantum_up_button_up():
	if quantum > 18: return
	quantum += 1
	update_quantum_label()
	sfx.play()

func _on_quantum_down_button_up():
	if quantum > 1: 
		quantum -= 1
		update_quantum_label()
		sfx.play()
