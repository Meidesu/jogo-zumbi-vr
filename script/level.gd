extends Node3D

@export var TIME: float;
@export var player: XRToolsPlayerBody;
@export var EnemiesController: Node3D;

@onready var remainingTime: Timer = Timer.new() as Timer;

# Called when the node enters the scene tree for the first time.
func _ready():
	remainingTime.wait_time = TIME;
	remainingTime.timeout.connect(_on_timer_timeout);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func  _on_timer_timeout():
	pass
