extends CharacterBody3D
class_name Zombie
@export var coffin: PackedScene

var player: XRToolsPlayerBody = null;

var life = 100;
var dead = false;

var bodyDamage = 25;
var headDamage = 50;


const ATTACK_RANGE = 1.4;
const SPEED = 8.0;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

var _isAttacking: bool = false;
var _canAttack: bool = true;
var _isAttacked: bool = false;
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
	$Audio/BruhTimer.wait_time = randf_range(10.0, 50.0)
	

func _process(delta):
	dead = life <= 0
	velocity = Vector3.ZERO;
	nav_agent.set_target_position(player.global_transform.origin);
	var next_nav_point = nav_agent.get_next_path_position();
	var difference = (next_nav_point - global_transform.origin).normalized();
	
	if not _isAttacking and !_isAttacked:
		velocity = difference * SPEED * delta;
		
	if not is_on_floor():
		velocity.y -= gravity * delta;
	
	if _target_in_range() and !_isAttacking and _canAttack and !_isAttacked:
		player.is_under_attack = true;
		_isAttacking = true;
		_canAttack = false;
		cooldown.start();
	
	
	$Label3D.text = "VIDA: " + str(life)
	$Label3D.look_at(player.position)
	$Label3D.rotate_y(deg_to_rad(180))
		
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP);
	move_and_slide();
	
	play_animation()
#	animation_player.current_animation

func play_animation():
	if dead:
		if animation_player.current_animation != "Death":
			animation_player.play("Death")
		return
	
	if _isAttacked:
		if animation_player.current_animation != "Hit":
			animation_player.play("Hit")
		return
	
	if _isAttacking:
		if animation_player.current_animation != "Bite":
			animation_player.play("Bite")
		return
		
	if velocity != Vector3.ZERO:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
		return

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE;

func spawn_grave():
	var coffinInstance = coffin.instantiate()
	coffinInstance.position = self.global_position
	self.get_parent().add_child(coffinInstance)
	

func play_step_audio():
	if !$Audio/Footstep.playing:
		$Audio/Footstep.play()

func play_hit_audio():
	if !$Audio/Hit.playing:
		$Audio/Hit.play()

func play_death_audio():
	if !$Audio/Death.playing:
		$Audio/Death.play()

func play_fall_audio():
	if !$Audio/Fall.playing:
		$Audio/Fall.play()

func _on_animation_finished(anim_name):
	if anim_name == "Bite":
		_isAttacking = false;
		player.is_under_attack = false;
	
	if anim_name == "Hit":
		_isAttacked = false;

func _on_cooldown_timeout():
	_canAttack = true;


func takeDamage(amount):
	life -= amount


func _on_damage_area_area_entered(area):
	if life > 0:
		if area.is_in_group("Bullet"):
			_isAttacked = true
			takeDamage(bodyDamage)


func _on_damage_area_body_entered(body):
	if body is RigidBody3D and (body.velocity.x >= 2 or body.velocity.z >= 2):
		takeDamage(10);


func _on_bruh_timer_timeout():
	$Audio/Bruh.play()
	$Audio/BruhTimer.wait_time = randf_range(10.0, 50.0)
