extends KinematicBody2D


export (Vector2) var velocity

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		# Works when collided shape is not wound
		velocity = velocity.bounce(collision.normal)
		# Use this if the collisionshape is round
		# velocity.x *= 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
