extends Node2D

@onready var button_label = $UI/Control/Button/Label
@onready var window = $UI/Window
@onready var startButton = $UI/Control/Button
@onready var memory = $UI/Control/Memory
@onready var queue = $UI/Control/Queue
@onready var table = $UI/Table
@onready var ui = $UI
const GLOBAL_TIMER = preload("res://Scenes/global_timer.tscn")

var number_of_processes_set: bool = false
var global_timer_reference 

var is_table_visible: bool = false


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_P:
					if not is_table_visible: memory.pause_execution() # DONE
				KEY_C:
					if not is_table_visible: memory.continue_or_unpause() # DONE
				KEY_N:
					if not is_table_visible: queue.append(Process.new()) # DONE
				KEY_E:
					if not is_table_visible: memory.block_current_process() # DONE
				KEY_W:
					if not is_table_visible: memory.error_and_terminate_current_process() # DONE
				KEY_T:
					if table.visible:
						memory.continue_or_unpause()
						table.visible = false
						is_table_visible = false
						table.clean_references()
					else:
						memory.pause_execution()
						table.populate_with_references()
						table.visible = true
						is_table_visible = true

# Start button
func _on_button_button_up():
	if not number_of_processes_set:
		# First let's prompt user with how many processes would like the program to start with
		window.visible = true
		button_label.text = "PAUSAR"
		number_of_processes_set = true
		global_timer_reference = GLOBAL_TIMER.instantiate()
		window.add_child_to_parent_when_start(ui, global_timer_reference)
	else:
		memory.pause_execution()
		
		if memory.is_paused():
			button_label.text = "CONTINUAR"
		else:
			button_label.text = "PAUSAR"
