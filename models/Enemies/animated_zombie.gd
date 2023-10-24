extends CharacterBody3D

@export var coffin: PackedScene

var player: XRToolsPlayerBody = null;

var life = 100;

var bodyDamage = 25;
var headDamage = 50;


const ATTACK_RANGE = 1.4;
const SPEED = 8.0;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");







var _isAttacking: bool = false;
var _canAttack: bool = true;
#var animation_player.current_animation: String;

@export var player_path: NodePath;

@onready var animation_player: AnimationPlayer = $AnimationPlayer;
@onready var cooldown = $Cooldown
@onready var nav_agent = $NaviAgentZombie

@onready var bodyArea = $RootNode/Body
@onready var headArea = $RootNode/Head

func _ready():
	player = get_node(player_path);
	animation_player.play("Walk");
	print(player)
	

func _process(delta):
	var dead = life <= 0
	
	velocity = Vector3.ZERO;
	nav_agent.set_target_position(player.global_transform.origin);
	var next_nav_point = nav_agent.get_next_path_position();
	var difference = (next_nav_point - global_transform.origin).normalized();
	
	if not _isAttacking:
		velocity = difference * SPEED * delta;
		
	if not is_on_floor():
		velocity.y -= gravity * delta;
	
	if _target_in_range() and !_isAttacking and _canAttack:
		player.is_under_attack = true;
		_isAttacking = true;
		_canAttack = false;
		cooldown.start();
	
	if dead:
		spawn_grave();
		queue_free();
		
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP);
	move_and_slide();
	
#	animation_player.current_animation
	if _isAttacking:
		if animation_player.current_animation != "Bite":
			animation_player.play("Bite")
	elif velocity != Vector3.ZERO:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE;

func spawn_grave():
	var coffinInstance = coffin.instantiate()
	self.add_child(coffinInstance)
	

func _on_animation_finished(anim_name):
	if anim_name == "Bite":
		_isAttacking = false;
		player.is_under_attack = false;

func _on_cooldown_timeout():
	_canAttack = true;


func takeDamage(amount):

	life -= amount



#func _on_damage_area_body_entered(body):
#	if body is Bullet:
#		takeDamage(bodyDamage)


func _on_damage_area_area_entered(area):
	if area.is_in_grup("Bullet"):
		takeDamage(bodyDamage)
