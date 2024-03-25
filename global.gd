extends Node

@onready var levelScene: PackedScene = preload("res://scenes/level.tscn");

func _ready():
	randomize();

func start_level():
	get_tree().change_scene_to_packed(levelScene);

func quit_game():
	get_tree().quit();
