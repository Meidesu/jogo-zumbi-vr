extends XRToolsPickable

var can_fire: bool = true;

@export var bullet: PackedScene;
@export var bullet_speed = 10.0;

func action():
	super.action();
	
	if can_fire:
		_spawn_bullet();
		can_fire = false;
		$Cooldown.start();
		
func _spawn_bullet():
	if bullet:
		var new_bullet: RigidBody3D = bullet.instantiate();
		if new_bullet:
			new_bullet.set_as_toplevel(true);
			add_child(new_bullet);
			new_bullet.transform = $SpawnPoint.global_transform;
			new_bullet.linear_velocity = new_bullet.transform.basis.z * bullet_speed

func _on_cooldown_timeout():
	can_fire = true;
	pass # Replace with function body.
