extends Area2D

signal pickup

var textures = {
	'cherry': 'res://assets/sprites/cherry.png',
	'gem': 'res://assets/sprites/gem.png'
}


func init(type, pos):
	$Sprite.texture = load(textures[type])
	position = pos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Collectible_body_entered(body):
	emit_signal('pickup')
	queue_free()
