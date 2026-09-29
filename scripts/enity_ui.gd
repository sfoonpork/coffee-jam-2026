class_name EntityUI
extends Control

var offset = Vector2(0.0, -48.0) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = offset

func set_health_color(color: Color) -> void:
	$Label.modulate = color
	$ColorRect.modulate = color
	
func set_health(amount: float) -> void:
	$Label.text = str(int(amount))
	var length: float = amount / 4.0
	var height: float = 8.0
	
	$ColorRect.size = Vector2(length, height)
	$ColorRect.position = Vector2(-length/2.0, height/2.0)
