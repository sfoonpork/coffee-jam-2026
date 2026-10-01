class_name CardUI
extends Button

var upgrade_modulate: Color

func _on_button_down() -> void:
	var upgrade_modulate_pressed = upgrade_modulate
	upgrade_modulate_pressed.v = 0.5
	self.modulate = upgrade_modulate_pressed


func _on_button_up() -> void:
	self.modulate = upgrade_modulate


func set_upgrade_texture(texture: CompressedTexture2D, modulate: Color) -> void:
	upgrade_modulate = modulate
	$TextureRect.modulate = upgrade_modulate
	$TextureRect.texture = texture


func set_title_text(msg: String) -> void:
	$TitleLabel.text = msg


func set_details_text(msg: String) -> void:
	$DetailsLabel.text = msg


func play_destroy() -> void:
	queue_free()
