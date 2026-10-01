class_name CardUI
extends Button

var upgrade_modulate: Color
var amplitude: float = 0.0
var amplitude_target: float = 1.0
var noise = FastNoiseLite.new()
var time: float = 0.0
var start_position: Vector2
var offset: float
var index: int
var upgrade: UpgradeStats

func _ready() -> void:
	SoundManager.play(start_position, preload("res://sfx/card.mp3"), 0.0, 1.0 + float(index) / 4.0)
	noise.frequency = 8.0
	offset += 1.0
	update_position()
	
func _process(delta: float) -> void:
	time += delta
	amplitude += (amplitude_target - amplitude) * clamp(8.0 * delta, 0.0, 1.0)
	offset += (0.0 - offset) * clamp(8.0 * delta, 0.0, 1.0)
	$NinePatchRect.size = Vector2(192.0 + amplitude, 256 + amplitude)
	$NinePatchRect.position = -Vector2.ONE * amplitude / 2.0
	update_position()


func update_position() -> void:
	self.rotation_degrees = offset * 5.0
	self.position = start_position + get_viewport_rect().size / 2.0
	self.position += Vector2.DOWN * offset * 32.0
	var x = noise.get_noise_1d(time)
	var y = noise.get_noise_1d(time + 60.0)
	var noise_vector = Vector2(x, y - amplitude) * amplitude
	self.position += noise_vector


func _on_button_down() -> void:
	var upgrade_modulate_pressed = upgrade_modulate
	upgrade_modulate_pressed.v = 0.5
	self.modulate = upgrade_modulate_pressed


func _on_button_up() -> void:
	self.modulate = upgrade_modulate
	SoundManager.play(start_position, preload("res://sfx/coin.mp3"), 0.0, 1.0 + float(index) / 4.0)


func set_upgrade_texture(texture: CompressedTexture2D, modulate: Color) -> void:
	upgrade_modulate = modulate
	upgrade_modulate = Color.WHITE
	$TextureRect.modulate = upgrade_modulate
	$TextureRect.texture = texture
	$TextureRect/TextureRect2.texture = texture
	$TextureRect/TextureRect3.texture = texture
	$TextureRect/TextureRect4.texture = texture
	$TextureRect/TextureRect5.texture = texture


func set_title_text(msg: String) -> void:
	$TitleLabel.text = msg


func set_details_text(msg: String) -> void:
	$DetailsLabel.text = msg


func play_destroy() -> void:
	queue_free()


func _on_mouse_entered() -> void:
	amplitude_target = 4.0
	SoundManager.play(start_position, preload("res://sfx/hover.mp3"), 0.0, 1.0 + float(index) / 4.0)


func _on_mouse_exited() -> void:
	amplitude_target = 1.0
	SoundManager.play(start_position, preload("res://sfx/unhover.mp3"), 0.0, 1.0 + float(index) / 4.0)
