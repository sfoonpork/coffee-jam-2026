class_name Bullet
extends Area2D

var direction: Vector2
var ignore: String
var speed: float = 500.0

@onready var despawn_timer: Timer = $DespawnTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	despawn_timer.start(5.0)
	despawn_timer.timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.rotation = atan2(direction.y, direction.x) + PI / 2.0
	self.position += direction.normalized() * speed * delta


func _on_body_entered(body: Entity) -> void:
	body.take_damage(speed / 10.0)
	queue_free()
	pass # Replace with function body.
