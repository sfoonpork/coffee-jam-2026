class_name Player
extends Entity

# wobble on speed stop (follow thru animation)
@export var look_sprite: Sprite2D
@export var player_stats_label: Label

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
	stats = stats.duplicate()
	stats.health = stats.max_health
	stats.bullet_damage_factor = 1
	#stats.bullet_espresso_count = 1

	self.position = get_viewport_rect().size / 2.0
	
	apply_look()
	
	Signals.set_player_stat.connect(set_stat)
	Signals.add_player_stat.connect(add_stat)
	Signals.mul_player_stat.connect(mul_stat)




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
	
	#print(stats.bullet_espresso_count)
	player_stats_label.text = ""
	player_stats_label.text += "\nMax Health: " + str(stats.max_health)
	player_stats_label.text += "\nBody Damage: " + str(stats.body_damage)
	player_stats_label.text += "\nHealth Regen Rate: " + str(stats.health_regen_rate)
	player_stats_label.text += "\n-\nSpeed: " + str(stats.speed)
	player_stats_label.text += "\n-\nFire Rate: " + str(stats.fire_rate)
	player_stats_label.text += "\nBullet Speed: " + str(stats.bullet_speed)
	player_stats_label.text += "\nBullet Damage: " + str(stats.bullet_damage)
	player_stats_label.text += "\nBullet Damage Multiplier: " + str(stats.bullet_damage_factor)
	player_stats_label.text += "\n-\nMilk Count: " + str(stats.bullet_milk_count)
	player_stats_label.text += "\nEspresso Count: " + str(stats.bullet_espresso_count)
	player_stats_label.text += "\nChocolate Count: " + str(stats.bullet_chocolate_count)
	player_stats_label.modulate.a = 0.5
	
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
				fire_all(look, "player", Color.WHITE)
		else:
			if fire_timer <= 0.0:
				fire_timer = 0.0

func die() -> void:
	GameData.end_state = "You were defeated"
	Signals.player_died.emit()
	super()


func set_stat(property: String, value: Variant) -> void:
	stats.set(property, value)
	print(str(property) + ": =" + str(value))


func add_stat(property: String, value: Variant) -> void:
	stats.set(property, stats.get(property) + value)
	print(str(property) + ": +" + str(value))


func mul_stat(property: String, value: Variant) -> void:
	stats.set(property, stats.get(property) * value)
	print(str(property) + ": *" + str(value))
