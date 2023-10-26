extends Node3D
class_name Bullet

const SPEED = 60.0;

@onready var mesh = $MeshInstance3D;
@onready var ray = $RayCast3D;


func _ready():
	self.add_to_group("Bullet")

func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta;


func _on_life_timer_timeout():
	queue_free();
