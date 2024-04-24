extends Control

@onready var process_container = $Panel/MarginContainer/ScrollContainer/VBoxContainer/ProcessContainer

const PROCESS = preload("res://Scenes/Process.tscn")

func is_empty() -> bool:
	return process_container.get_child_count() == 0

func append(process_resource: Process):
	var new_process = PROCESS.instantiate()
	new_process.asigned_process = process_resource
	process_container.add_child(new_process)
	
func append_node(process: Control) -> void:
	process_container.add_child(process)
	process_container.move_child(process, 0)

func return_all_process_nodes() -> Array[Node]:
	# returns the references
	return process_container.get_children()

func pop_n_processes(n_processes: int) -> Array[Control]:
	var retrieved_processes: Array[Control] = []
	
	var idx: int = n_processes
	while idx >= 0 and process_container.get_child_count() > 0:
		var extracted_process: Control = process_container.get_child(0)
		process_container.remove_child(extracted_process)
		retrieved_processes.append(extracted_process)
		idx -= 1
	
	return retrieved_processes
