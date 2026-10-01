class_name Bullet
extends Area2D

var BULLET_DESTROY_SPEED = 25.0

var direction: Vector2
var accel_rate: float
var ignore: String
var damage: float
var speed: float
var damage_factor: float
var collided: Dictionary
var valid: bool

var destroying: bool = false
var destroy_time: float = 0.0

@onready var despawn_timer: Timer = $DespawnTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	SoundManager.play(self.position, preload("uid://bhemw3qb5gfoc"), -12.0, 4.0 + randf() * 2.0)
	valid = true
	collided = {}
	despawn_timer.start(5.0)
	despawn_timer.timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	speed += accel_rate * delta
	self.rotation = atan2(direction.y, direction.x) + PI / 2.0
	self.position += direction.normalized() * speed * delta
	
	if destroying:
		return
	
	if not valid:
		play_destroy()


func _on_body_entered(body: CollisionObject2D) -> void:
	
	# currently playing the animation, don't register interactions
	if destroying:
		return
	
	# bullets and entities in the same group shouldn't hit each other
	if body.is_in_group(ignore):
		return
		
	if not valid:
		return

	var entity = body as Entity
	if entity:
		valid = false
		#body.take_damage(speed / 10.0)
		body.take_damage(damage * damage_factor)
		#var direction_to_entity = entity.position - self.position
		#body.take_knockback(direction_to_entity.normalized() * 250.0)
		body.take_knockback(direction.normalized() * 250.0)
		play_destroy()
	


func set_texture(texture: CompressedTexture2D) -> void:
	$Sprite2D.texture = texture


func _on_area_entered(area: Area2D) -> void:
	
	# currently playing the animation, don't register interactions
	if destroying:
		return
	
	var bullet = area as Bullet
	if bullet:
		
		# bullets and entities in the same group shouldn't hit each other
		if bullet.ignore == self.ignore: return
		
		# debounce
		if bullet.collided.has(self): return
		if self.collided.has(bullet): return
		
		# collide
		bullet.collided[self] = true
		collided[bullet] = true
		
		var prev_bullet_speed = bullet.speed
		var prev_speed = speed
		
		if bullet.speed > 0:
			bullet.speed -= abs(prev_speed)
		else:
			bullet.speed += abs(prev_speed)
		if speed > 0:
			speed -= abs(prev_bullet_speed)
		else:
			speed += abs(prev_bullet_speed)
		
		if sign(prev_bullet_speed) != sign(bullet.speed):
			bullet.play_destroy()
			
		if sign(prev_speed) != sign(speed):
			play_destroy()


# TODO: play destroy animation (fadeout, shrink) for polish
func play_destroy() -> void:
	destroying = true
	queue_free()
	pass
