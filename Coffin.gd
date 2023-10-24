extends Node3D

func _ready():
	$AnimationPlayer.play("fall");





func _on_disappear_timer_timeout():
	queue_free()
