extends Control

@export var asigned_process = Process
@onready var operation_label = $Control/OperationLabel
@onready var progress_bar = $Control/ProgressBar
@onready var id_label = $Control/IDLabel
@onready var timer = $Timer
@onready var blocked_progress_bar = $Control/BlockedProgressBar
@onready var block_timer = $BlockTime
@onready var error_background_color = $Control/ErrorBackgroundColor

var was_terminated: bool = false

var last_time: float = 0.0
var saved_time_left: float = -99
var blocked_saved_time_left: float = -99

var time_left_in_blocked: float = 8.0

var stopped: bool = false
var blocked: bool = false
var blocked_pause: bool = false

# Times
var arrival_time: String = "0"
var finalization_time: String
var response_time: String
var time_spent_in_execution: int

func _ready():
	operation_label.text = asigned_process.operation
	id_label.text = asigned_process.id
	timer.wait_time = asigned_process.time_in_execution
	progress_bar.max_value = asigned_process.time_in_execution
	timer.connect("timeout", terminate)
	blocked_progress_bar.visible = false
	blocked_progress_bar.max_value = time_left_in_blocked
	block_timer.connect("timeout", remove_from_blocked)
	
func _process(_delta):
	if not stopped:
		progress_bar.value = timer.time_left
		if last_time != timer.time_left:
			last_time = timer.time_left
			GlobalManager.change_time(timer.time_left)
	elif blocked and not blocked_pause:
		blocked_progress_bar.value = block_timer.time_left

func execute():
	progress_bar.visible = true
	if saved_time_left == -99:
		response_time = GlobalManager.snap_global_time()
		timer.start()
	else:
		timer.start(saved_time_left)

func pause() -> void:
	if not blocked:
		if stopped:
			timer.start(saved_time_left)
			stopped = false
		else:
			saved_time_left = timer.time_left
			time_spent_in_execution = asigned_process.time_in_execution - timer.time_left
			timer.stop()
			stopped = true
	else:
		if blocked_pause:
			unpause()
		else:
			blocked_saved_time_left = block_timer.time_left
			block_timer.stop()
			blocked_pause = true

func unpause():
	block_timer.start(blocked_saved_time_left)
	blocked_pause = false

func block() -> void:
	blocked = true
	stopped = true

	saved_time_left = timer.time_left
	time_spent_in_execution = asigned_process.time_in_execution - timer.time_left
	timer.stop()
	progress_bar.visible = false
	blocked_progress_bar.visible = true
	
	block_timer.start()

func is_paused() -> bool:
	return stopped

func terminate():
	GlobalManager.play_finished_sound()
	GlobalManager.process_finished(self, get_parent())

func error_and_terminate():
	error_background_color.visible = true
	operation_label.text = "ERROR"
	was_terminated = true
	time_spent_in_execution = asigned_process.time_in_execution - timer.time_left
	timer.stop()
	terminate()

func remove_from_blocked():
	blocked = false
	stopped = false
	blocked_progress_bar.visible = false
	GlobalManager.force_to_memory(self, get_parent())
	
func return_info_row_format() -> Array[String]:
	var information: Array[String] = []
	# ID
	information.append(asigned_process.id)
	# Operation
	information.append(asigned_process.operation)
	# Tiempo restante:
	if finalization_time.length() > 0:
		information.append("0")
	else:
		information.append(str(asigned_process.time_in_execution - time_spent_in_execution))
	# TME:
	information.append(str(asigned_process.time_in_execution))
	# TL:
	information.append(arrival_time)
	# TF:
	if finalization_time.length() > 0:
		information.append(finalization_time)
	else:
		information.append("")
	# Tiempo de respuesta
	if response_time.length() > 0:
		information.append(response_time)
	else:
		information.append("")
	
	# Tiempo de retorno
	if finalization_time.length() > 0:
		information.append(str(int(finalization_time) - int(arrival_time)))
	else:
		information.append("")
	# Tiempo de Servicio = Tiempo Total de CPU - Tiempo de Espera
	if finalization_time.length() > 0:
		var time_in_service
		if was_terminated: time_in_service = time_spent_in_execution
		else: time_in_service = asigned_process.time_in_execution # TME
		information.append(str(time_in_service))
			
	# Tiempo de Espera = Tiempo de retorno - tiempo de servicio
		information.append(str((int(finalization_time) - int(arrival_time)) - time_in_service))
	# Solve operation and place string
		if was_terminated:
			information.append("ERROR")
		else:
			information.append(evaluate_math_expression(asigned_process.operation))
	else:
		information.append("")
		information.append("")
		information.append("")

	

	return information

func evaluate_math_expression(expression: String) -> String:
	# Supported operators
	var operators = ["+", "-", "*", "/"]
	
	# Find the operator
	var operator_index = -1
	for op in operators:
		operator_index = expression.find(op)
		if operator_index != -1:
			break
	
	# Split the expression into two numbers and the operator
	var num1 = expression.substr(0, operator_index).to_float()
	var num2 = expression.substr(operator_index + 1, expression.length()).to_float()
	var op = expression.substr(operator_index, 1)
	
	# Perform the operation based on the operator
	match op:
		"+" : return str(num1 + num2)
		"-" : return str(num1 - num2)
		"*" : return str(num1 * num2)
		"/" : return str(snapped(num1 / num2, 0.01))
	
	return "FATAL ERROR"

func set_arrival_time(_arrival_time: String) -> void:
	arrival_time = _arrival_time

func set_finalization_time(_finalization_time: String) -> void:
	finalization_time = _finalization_time
