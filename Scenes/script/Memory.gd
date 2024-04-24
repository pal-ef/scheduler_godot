extends Control

const PROCESS = preload("res://Scenes/Process.tscn")
@onready var process_container = $PanelContainer/Panel/VBoxContainer/MarginContainer/ProcessContainer
@onready var blocked_process_container = $PanelContainer/Panel/VBoxContainer/MarginContainer2/BlockedProcessContainer
@onready var process_in_execution = $ProcessInExecution
const MAX_ELEMENTS_IN_MEMORY: int = 4

func isFull(): 
	return (\
	process_container.get_child_count() + \
	process_in_execution.get_child_count() +\
	blocked_process_container.get_child_count() \
	) >= MAX_ELEMENTS_IN_MEMORY

func append(process_resource: Process) -> void:
	var process: Control = PROCESS.instantiate()
	process.asigned_process = process_resource
	process_container.add_child(process)

func append_process_node(process: Control) -> void:
	process_container.add_child(process)

func retrieve_from_queue(n_processes: int) -> void:
	var extracted_processes: Array[Control] = GlobalManager.retrieve_from_queue(n_processes)
	
	for process in extracted_processes:
		append_process_node(process)
		process.set_arrival_time(GlobalManager.snap_global_time())

func start_execution() -> void:
	process_in_execution.get_child(0).execute()

func pause_execution() -> void:
	# TODO Stop Global Timer
	GlobalManager.pause_global_timer()
	if process_in_execution.get_child_count() > 0:
		process_in_execution.get_child(0).pause()
	
	# DONE Blocked processes should also stop
	for blocked_process in blocked_process_container.get_children():
		blocked_process.pause()
	
func block_current_process() -> void:
	if process_in_execution.get_child_count() > 0:
		var blocked_process = process_in_execution.get_child(0)
		if blocked_process != null:
			process_in_execution.remove_child(blocked_process)
			blocked_process_container.add_child(blocked_process)
			blocked_process.block()
	
func is_paused() -> bool:
	return process_in_execution.get_child(0).is_paused()
	
func is_exceeding():
	return (\
	process_container.get_child_count() + \
	process_in_execution.get_child_count() +\
	blocked_process_container.get_child_count() \
	) > MAX_ELEMENTS_IN_MEMORY

func return_last_to_queue():
	var process = process_container.get_child(-1) # get last child
	process_container.remove_child(process)
	GlobalManager.return_to_queue(process)
	
func continue_or_unpause() -> void:
	# unpause global timer
	GlobalManager.pause_global_timer()
	
	# if its paused unpause by calling pause on a paused node
	if process_in_execution.get_child_count() > 0:
		if not is_paused(): return
		process_in_execution.get_child(0).pause()
	
	# Unpause blocked 
	if blocked_process_container.get_child_count() > 0:
		for blocked_process in blocked_process_container.get_children():
			blocked_process.pause()
		
func error_and_terminate_current_process() -> void:
	process_in_execution.get_child(0).error_and_terminate()
	
func return_all_process_nodes():
	var all_nodes: Array[Node] = []
	# Should return all the nodes from all the containers
	# This code might break if there are none children in any container TODO
	
	# Return references to blocked
	for child in blocked_process_container.get_children(): all_nodes.append(child)
	
	# Return references from process container
	for child in process_container.get_children(): all_nodes.append(child)
	
	# Return references from executor
	if process_in_execution.get_child_count() > 0:
		all_nodes.append(process_in_execution.get_child(0))
	
	return all_nodes
	

func _process(_delta):
	# if there is no process in execution but there is processes in memory
	if process_in_execution.get_child_count() == 0 and process_container.get_child_count() != 0:
		var process_to_be_executed = process_container.get_child(0)
		process_container.remove_child(process_to_be_executed)
		process_in_execution.add_child(process_to_be_executed)
		start_execution()

	if not isFull() and not GlobalManager.is_queue_empty():
		retrieve_from_queue((MAX_ELEMENTS_IN_MEMORY - 1) - (process_container.get_child_count() + process_in_execution.get_child_count()))

	if is_exceeding():
		while is_exceeding():
			return_last_to_queue()
