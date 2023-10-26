extends Node3D
func _ready():
	$AnimationPlayer.play("fall");
	if $DisappearTimer.is_stopped(): $DisappearTimer.start()

func _on_disappear_timer_timeout():
	$AnimationPlayer.play("disappear")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "disappear":
		queue_free();
