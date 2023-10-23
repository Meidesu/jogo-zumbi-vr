extends XRToolsPickable

var can_fire: bool = true;

@export var bullet: PackedScene;
@export var bullet_speed = 10.0;

@onready var gun_barrel = $RayCast3D;



func action():
	super.action();
	
	if can_fire:
		_spawn_bullet();
		can_fire = false;
		$Cooldown.start();
		
#	if can_fire:
#		_spawn_bullet();
#		can_fire = false;
#		$Cooldown.start();
		
func _spawn_bullet():
	if bullet:
		var new_bullet = bullet.instantiate();
		
		new_bullet.position = gun_barrel.global_position;
		new_bullet.transform.basis = gun_barrel.global_transform.basis;
		get_parent().add_child(new_bullet)
		

func _on_cooldown_timeout():
	can_fire = true; # Replace with function body.
