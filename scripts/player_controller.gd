class_name Player
extends CharacterBody2D

# wobble on speed stop (follow thru animation)
@export var look_sprite: Sprite2D
@export var bullet_scene: PackedScene

var stats: PlayerStats = preload("uid://bkq410kip5nju")

# Accelarate to move speed
var accel: Vector2 = Vector2.ZERO
var accel_speed: float = 50.0
var max_speed: float = 250.0

# General movement
var move: Vector2 = Vector2.ZERO
var speed: float = 0.0

var moving: bool = false

# Looking
var look: Vector2 = Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = get_viewport().size / 2.0
	apply_look()
	look_sprite.position = look.normalized() * 32.0
	look_sprite.rotation = atan2(look.y, look.x)
	
	stats.health = stats.max_health


func apply_accel(action: String, direction: Vector2) -> void:
	
	if Input.is_action_just_pressed(action):
		accel += direction
		moving = true
	if Input.is_action_just_released(action):
		if moving:
			accel -= direction
			if accel.length_squared() == 0.0:
				moving = false


func apply_look() -> void:

	var pos_mouse: Vector2 = get_viewport().get_mouse_position()
	var pos_player: Vector2 = self.position
	look = pos_mouse - pos_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	apply_accel("ui_up", Vector2.UP)
	apply_accel("ui_down", Vector2.DOWN)
	apply_accel("ui_left", Vector2.LEFT)
	apply_accel("ui_right", Vector2.RIGHT)
	
	if accel.length_squared() > 0.0:
		move += accel.normalized() * accel_speed
		#print("accel")
		if move.length() > max_speed:
			move = move.normalized() * max_speed
			#print("max")
	else:
		if move.length_squared() > 0.0:
			var move_last = move
			move -= move.normalized() * accel_speed
			#print("deccel")
			if move.dot(move_last) <= 0.0:
				move = Vector2.ZERO
				#print("reset")
	
	#self.position += move * delta
	#self.set_velocity(move * delta)
	self.set_velocity(move)
	move_and_slide()
	
	apply_look()
	
	if look.length_squared() > 0.0:
		look_sprite.position = look.normalized() * 32.0
		look_sprite.rotation = atan2(look.y, look.x)
	
	if Input.is_action_just_pressed("ui_accept"):
		#TODO: hook up bullet spawning to world (position, direction, ignore tag) - hits targets when collisions provided
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.position = position + look.normalized() * 32.0
		bullet.direction = look
		bullet.ignore = "player"
		add_sibling(bullet)
		
		GameData.bullets_fired += 1
		print("fired")
	
	pass


func take_damage(amount: float) -> void:
	stats.health -= amount
	if stats.health <= 0.0:
		Signals.player_died.emit()
		queue_free()
