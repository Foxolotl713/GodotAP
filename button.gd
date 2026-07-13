extends Button

func _physics_process(_delta: float) -> void:
	if is_pressed():
		get_tree().quit()
