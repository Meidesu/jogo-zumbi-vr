extends RigidBody3D


func _on_life_timer_timeout():
	queue_free();
