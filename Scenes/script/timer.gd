extends Label

func _process(_delta):
	text = str(GlobalManager.get_time())
