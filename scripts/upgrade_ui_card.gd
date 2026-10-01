class_name CardUI
extends Button

var upgrade_modulate: Color
var amplitude: float = 0.0
var amplitude_target: float = 0.0
var noise = FastNoiseLite.new()
var time: float = 0.0

func _ready() -> void:
	noise.frequency = 8.0
	
func _process(delta: float) -> void:
	time += delta
	amplitude += (amplitude_target - amplitude) * clamp(8.0 * delta, 0.0, 1.0)
	var x = noise.get_noise_1d(time)
	var y = noise.get_noise_1d(time + 60.0)
	#var pos = Vector2(x, y) * amplitude
	var pos = Vector2(0, -amplitude/2.0)
	$NinePatchRect.position = pos



func _on_button_down() -> void:
	var upgrade_modulate_pressed = upgrade_modulate
	upgrade_modulate_pressed.v = 0.5
	self.modulate = upgrade_modulate_pressed


func _on_button_up() -> void:
	self.modulate = upgrade_modulate


func set_upgrade_texture(texture: CompressedTexture2D, modulate: Color) -> void:
	upgrade_modulate = modulate
	upgrade_modulate = Color.WHITE
	$TextureRect.modulate = upgrade_modulate
	$TextureRect.texture = texture


func set_title_text(msg: String) -> void:
	$TitleLabel.text = msg


func set_details_text(msg: String) -> void:
	$DetailsLabel.text = msg


func play_destroy() -> void:
	queue_free()


func _on_mouse_entered() -> void:
	amplitude_target = 16.0


func _on_mouse_exited() -> void:
	amplitude_target = 0.0
