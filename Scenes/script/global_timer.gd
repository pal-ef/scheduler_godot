extends Label

var time_elapsed = 0.0
var paused: bool = false

func _ready() -> void:
	GlobalManager.register_new_global_timer(self)

func _process(delta):
	if not paused:
		time_elapsed += delta
		text = "CONTADOR GLOBAL:   " + str(int(time_elapsed))+ "\nQUANTUM: " + str(GlobalManager.get_quantum())

func string_snaptime():
	return str(int(time_elapsed))

func pause() -> void:
	if paused:
		paused = false
	else: 
		paused = true

