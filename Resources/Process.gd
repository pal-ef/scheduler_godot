extends Resource
class_name Process

@export var id: String = generate_unique_id()
@export var operation: String = generate_basic_operation()
@export var time_in_execution: int = randi_range(3, 18)

func generate_unique_id() -> String:
	var id_str: String = "used"
	while not GlobalManager.is_id_unique(id_str):
		id_str = ""
		for i in range(5):
			id_str += str(randi_range(0, 9))  # Generate a random digit between 0 and 9
		
	GlobalManager.add_id(id_str)
	return id_str  # Convert the string of digits to an integer

func generate_basic_operation() -> String:
	# Generate random numbers between 0 and 9
	var num1 = randi_range(1, 9)
	var num2 = randi_range(1, 9)

	# Randomly choose an operator
	var operator_index = randi() % 4
	var operator_str = ""
	
	match operator_index:
		0: operator_str = "+" # Addition
		1: operator_str = "-" # Subtraction
		2: operator_str = "*" # Multiplication
		3: operator_str = "/" # Division
	
	# Construct the operation string
	var _operation = str(num1) + " " + operator_str + " " + str(num2)

	return _operation
