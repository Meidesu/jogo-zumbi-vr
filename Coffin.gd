extends Node3D
func _ready():
	$AnimationPlayer.play("fall");
	if $DisappearTimer.is_stopped(): $DisappearTimer.start()

func _on_disappear_timer_timeout():
	$AnimationPlayer.play("disappear")
