extends Node2D


onready var pickups = $PickupsTiles

# Called when the node enters the scene tree for the first time.
func _ready():
	pickups.hide()
	$Player.start($PlayerSpawn.position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
