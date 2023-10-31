extends Node3D

@onready var cript = $"../map/World/crypt"
@onready var playerPath = "../../XROrigin3D/PlayerBody"
@onready var enemyScene: PackedScene = preload("res://models/Enemies/animated_zombie.tscn")

@onready var spawnPosition = cript.get_node("SpawnEnemyPos").global_position
@onready var animationSpawnPlayer: AnimationPlayer = cript.get_node("AnimationPlayer")


func spawnEnemy(pos):
	var enemyInstance = enemyScene.instantiate() as Zombie;
	enemyInstance.position = pos
	enemyInstance.player_path = playerPath
	add_child(enemyInstance);
	
func _ready():
	spawnEnemy(spawnPosition)
	
	# Criando dinamicamente um signal para controlar a fechada do portão:
	animationSpawnPlayer.animation_finished.connect(playSpawnAnimation)	
	$SpawnTimer.start()
	
func _on_spawn_timer_timeout():
	animationSpawnPlayer.play("open_door")
	$SpawnTimer.start()
	
func playSpawnAnimation(anim_name):
	if anim_name == "open_door":
		spawnEnemy(spawnPosition)
		animationSpawnPlayer.play("close_door")

