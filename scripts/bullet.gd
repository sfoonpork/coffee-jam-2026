class_name Bullet
extends Area2D

var direction: Vector2
var ignore: String
var speed: float = 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.rotation = atan2(direction.y, direction.x) + PI / 2.0
	self.position += direction.normalized() * speed * delta


func setup(_origin: Vector2, _direction: Vector2, _ignore: String) -> void:
	position = _origin
	direction = _direction
	ignore = _ignore


func _on_body_entered(body: Enemy) -> void:
	body.take_damage(speed / 10.0)
	queue_free()
	pass # Replace with function body.
