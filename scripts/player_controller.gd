class_name Player
extends Entity

# wobble on speed stop (follow thru animation)
@export var look_sprite: Sprite2D


# Accelarate to move speed
# General movement
var speed: float = 0.0

var moving: bool = false

var fire_timer: float = 0.0
#var fire_rate: float = 8.0
var firing: bool = false

# Looking
var look: Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	super()
	stats = preload("uid://bkq410kip5nju")
	stats.health = stats.max_health
	
	self.position = get_viewport().size / 2.0
	
	apply_look()




func apply_look() -> void:

	var pos_mouse: Vector2 = get_viewport().get_mouse_position()
	var pos_player: Vector2 = self.position
	look = pos_mouse - pos_player

	if look.length_squared() > 0.0:
		look_sprite.position = look.normalized() * 32.0
		look_sprite.rotation = atan2(look.y, look.x)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	super(delta)
	
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	super.move(input_vector, delta)
	
	apply_look()
	
	if Input.is_action_just_pressed("ui_accept"):
		firing = true

	if Input.is_action_just_released("ui_accept"):
		firing = false
	
	if stats.fire_rate > 0.0:

		fire_timer -= delta
		
		if firing:
			while fire_timer <= 0.0:
				fire_timer += 1.0 / stats.fire_rate
				fire(look, "player", Color.WHITE)
		else:
			if fire_timer <= 0.0:
				fire_timer = 0.0


func die() -> void:
	Signals.player_died.emit()
	super()
	
