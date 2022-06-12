extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("anim")
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed('ui_select'):
		get_tree().change_scene(GameState.game_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
