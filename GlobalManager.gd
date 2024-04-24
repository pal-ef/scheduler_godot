extends Node

var required_processes_to_create: int = 0
@export var processes: Array[Process]

var registered_ids = {}

var time: int

var memory: Control
var queue: PanelContainer
var finished_queue: PanelContainer

var SFX: AudioStreamPlayer
const ROLLOVER_1 = preload("res://Assets/Bonus/rollover1.ogg")
const ROLLOVER_2 = preload("res://Assets/Bonus/rollover2.ogg")
const SWITCH_3 = preload("res://Assets/Bonus/switch3.ogg")

var global_timer: Label

func _ready():
	registered_ids["used"] = true
	memory = get_tree().get_first_node_in_group("memory")
	queue = get_tree().get_first_node_in_group("queue")
	finished_queue = get_tree().get_first_node_in_group("finished_queue")
	SFX = AudioStreamPlayer.new()
	SFX.stream = SWITCH_3
	get_tree().get_first_node_in_group("main").add_child(SFX)
	
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print_rich("[color=yellow]Appending new process...[/color]")

func populate() -> bool:
	populate_processes_array()
	if not populate_memory_if_able(): return false
	if not populate_queue_if_able(): return false
	return true

func populate_processes_array():
	processes = create_processes(required_processes_to_create)
	print_rich("[color=green]Processes created successfully![/color]")

func populate_memory_if_able() -> bool:
	if processes.size() == 0: return false

	while processes.size() > 0 and not memory.isFull():
		memory.append(processes.pop_front())
	
	return true

func populate_queue_if_able() -> bool:
	if processes.size() == 0: return false
	
	while processes.size() > 0:
		queue.append(processes.pop_front())
	
	return true

func set_number_of_processes(number: int) -> void:
	required_processes_to_create = number
	
func create_process() -> Process:
	return Process.new()
	
func create_processes(number: int) -> Array[Process]:
	var created_processes: Array[Process] = []
	for i in range(number):
		required_processes_to_create -= 1
		created_processes.append(Process.new())
	
	return created_processes

func append_array_of_processes_to_processes(array: Array[Process]) -> Array[Process]:
	var copy_of_processes = processes;
	copy_of_processes.append_array(array)
	
	return copy_of_processes

func initialize_memory() -> void:
	if required_processes_to_create > 4:
		memory.initialize(processes.slice(0, 4))
	else:
		memory.initilize(processes)

func is_queue_empty() -> bool:
	return queue.is_empty()
	
func retrieve_from_queue(n_processes: int) -> Array[Control]:
	return queue.pop_n_processes(n_processes)

func change_time(_time:int) -> void: time = _time

func get_time() -> int: return time + 1

func play_finished_sound() -> void:
	SFX.play()

func add_id(id: String) -> void:
	registered_ids[id] = true

func is_id_unique(id: String) -> bool:
	if registered_ids.has(id): return false
	return true

func process_finished(child: Control, parent) -> void:
	parent.remove_child(child)
	child.set_finalization_time(snap_global_time())
	finished_queue.append_node(child)

func return_to_queue(child: Control) -> void:
	queue.append_node(child)

func force_to_memory(child: Control, parent) -> void:
	parent.remove_child(child)
	memory.append_process_node(child)
	
func get_all_processes_references() -> Array[Node]:
	var all_nodes: Array[Node] = []
	
	# Extract all from finished
	all_nodes += finished_queue.return_all_process_nodes()
	
	# Extract all from memory
	# TODO
	all_nodes += memory.return_all_process_nodes()
	
	return all_nodes

func snap_global_time() -> String:
	return global_timer.string_snaptime()

func register_new_global_timer(_timer: Label):
	global_timer = _timer
	
func pause_global_timer() -> void:
	global_timer.pause()
