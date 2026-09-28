class_name Bullet
extends Area2D

var direction: Vector2
var accel_rate: float
var ignore: String
var speed: float
var speed_factor: float
var collided: Dictionary
var valid: bool

@onready var despawn_timer: Timer = $DespawnTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	SoundManager.play(self.position, preload("uid://bhemw3qb5gfoc"), -12.0, 4.0 + randf() * 2.0)
	#$ShootAudio.pitch_scale = 4.0 + randf() * 2.0
	#$ShootAudio.volume_db -= 12.0
	#$ShootAudio.play()
	#speed = 500.0
	valid = true
	collided = {}
	despawn_timer.start(5.0)
	despawn_timer.timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed += accel_rate * delta
	self.rotation = atan2(direction.y, direction.x) + PI / 2.0
	self.position += direction.normalized() * speed * speed_factor * delta
	if not valid:
		queue_free()


func _on_body_entered(body: CollisionObject2D) -> void:
	if body.is_in_group(ignore):
		return
		
	if not valid:
		return

	var entity = body as Entity
	if entity:
		valid = false
		body.take_damage(speed / 10.0)
		var direction_to_entity = entity.position - self.position
		body.take_knockback(direction_to_entity.normalized() * 250.0)
		queue_free()
	


func _on_area_entered(area: Area2D) -> void:
	
	var bullet = area as Bullet
	if bullet:
		
		if bullet.ignore == self.ignore:
			return
		
		if bullet.collided.has(self):
			return
		
		if self.collided.has(bullet):
			return
			
		var bullet_speed = bullet.speed
		bullet.collided[self] = true
		bullet.speed -= speed
		collided[bullet] = true
		speed -= bullet_speed
		
		if bullet.speed <= 0.0:
			bullet.queue_free()
			
		if self.speed <= 0.0:
			queue_free()
