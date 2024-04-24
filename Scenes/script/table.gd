extends Control
const ROW = preload("res://Scenes/Row.tscn")
@onready var row_container = $PanelContainer/VBoxContainer2/ScrollContainer/RowContainer

func populate_with_references() -> void:
	var global_references: Array[Node] = GlobalManager.get_all_processes_references()

	for reference in global_references:
		if reference != null:
			var new_row = ROW.instantiate()
			new_row.set_data(reference)
			row_container.add_child(new_row)

func clean_references() -> void:
	for child in row_container.get_children(): child.queue_free()
