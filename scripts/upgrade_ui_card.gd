class_name CardUI
extends Button


func _on_button_down() -> void:
	self.modulate = Color.GREEN


func _on_button_up() -> void:
	self.modulate = Color.WHITE



func set_title_text(msg: String) -> void:
	$TitleLabel.text = msg


func set_details_text(msg: String) -> void:
	$DetailsLabel.text = msg


func play_destroy() -> void:
	queue_free()
