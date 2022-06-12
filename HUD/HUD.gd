extends MarginContainer

onready var life_counter = [
	$HBoxContainer/LifeCounter/L1,
	$HBoxContainer/LifeCounter/L2,
	$HBoxContainer/LifeCounter/L3,
	$HBoxContainer/LifeCounter/L4,
	$HBoxContainer/LifeCounter/L5
]

func _on_Player_life_changed(value):
	for heart in range(life_counter.size()):
		life_counter[heart].visible = value > heart
		
func _on_Score_changed(value):
	$HBoxContainer/ScoreLabel.text = str(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
