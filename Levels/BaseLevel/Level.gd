extends Node2D

signal score_changed

var Collectible = preload("res://Collectibles/Collectible.tscn")

var score

onready var pickups = $PickupsTiles

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	emit_signal("score_changed", score)
	$Player.start($PlayerSpawn.position)
	set_camera_limits()
	pickups.hide()
	$Player.connect("dead", self, '_on_Player_dead')
	spawn_pickups()

func set_camera_limits():
	var map_size = $WorldTiles.get_used_rect()
	var cell_size = $WorldTiles.cell_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5)*cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5)*cell_size.x
	$Player/Camera2D.limit_top = 0
	
func spawn_pickups():
	for cell in pickups.get_used_cells():
		var id = pickups.get_cellv(cell)
		var type = pickups.tile_set.tile_get_name(id)
		if type in ['gem', 'cherry']:
			var c = Collectible.instance()
			var pos = pickups.map_to_world(cell)
			c.init(type, pos + pickups.cell_size/2)
			add_child(c)
			c.connect('pickup', self, 'on_Collectible_pickup')
			
func on_Collectible_pickup():
	score += 1
	emit_signal('score_changed', score)

func _on_Player_dead():
	GameState.restart()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Door_body_entered(body):
	GameState.next_level()
	pass # Replace with function body.


func _on_Ladder_body_entered(body):
	if body.name == "Player":
		body.is_on_ladder = true


func _on_Ladder_body_exited(body):
	if body.name == "Player":
		body.is_on_ladder = false
