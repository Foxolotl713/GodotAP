extends RichTextLabel

var speed=0.5

signal clicked()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible_ratio+=delta*speed


func _on_visibility_changed() -> void:
	visible_ratio=0



func _on_button_pressed() -> void:
	clicked.emit()
	self.queue_free()
