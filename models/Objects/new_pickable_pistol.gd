extends XRToolsPickable

var can_fire: bool = true;

@export var bullet: PackedScene;
@export var bullet_speed = 10.0;

@onready var gun_barrel = $RayCast3D;

@onready var REST_POSITION = global_position;

var shootTimer = 0;
var shootTimeout = 3;

var canDisappearTimer = 0;



func _process(delta):
	shootTimeout = clamp(shootTimeout, 0, 10)
	canDisappearTimer = clamp(canDisappearTimer, 0, 10)
	shootTimer += 1;

	if shootTimer >= shootTimeout:
		$OmniLight3D.visible = false;
		
	if global_position.y <= 0.25:
		canDisappearTimer += 1 
		if canDisappearTimer >= 10:
			global_position = REST_POSITION
			canDisappearTimer = 0;

func action():
	super.action();
	
	if can_fire:
		$OmniLight3D.visible = true
		shootTimer = 0;
		_spawn_bullet();
		$Cooldown.start();
		can_fire = false;
		
func _spawn_bullet():
	if bullet:
		var new_bullet = bullet.instantiate();
		
		new_bullet.position = gun_barrel.global_position;
		new_bullet.transform.basis = gun_barrel.global_transform.basis;
		get_parent().add_child(new_bullet)
		

func _on_cooldown_timeout():
	can_fire = true; # Replace with function body.
