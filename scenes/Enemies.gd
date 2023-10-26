extends Node3D

@onready var cript = $"../map/World/crypt"
@onready var playerPath = "../../XROrigin3D/PlayerBody"
@onready var enemyScene: PackedScene = preload("res://models/Enemies/animated_zombie.tscn")

@onready var spawnPosition = cript.get_node("SpawnEnemyPos").global_position


func spawnEnemy(pos):
	var enemyInstance = enemyScene.instantiate() as Zombie;
	enemyInstance.position = pos
	enemyInstance.player_path = playerPath
	add_child(enemyInstance);

func _ready():
	spawnEnemy(spawnPosition)
	if $SpawnTimer.is_stopped():
		$SpawnTimer.start()

func _on_spawn_timer_timeout():
	if get_child_count() <= 10:
		spawnEnemy(spawnPosition)
	$SpawnTimer.start()
