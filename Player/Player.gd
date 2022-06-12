extends KinematicBody2D

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity

enum States {IDLE, RUN, JUMP, HURT, DEAD}
var state
var anim
var new_anim
var velocity = Vector2()

func get_input():
	if state == States.HURT:
		return #No movements in this state
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	
	velocity.x = 0
	if right:
		velocity.x += run_speed
		$Sprite.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite.flip_h = true
	# Jumping only when on floor (we have no double jumps here!)
	if jump and is_on_floor():
		change_state(States.JUMP)
		velocity.y = jump_speed
	# States Changes according to Status
	if state == States.IDLE and velocity.x != 0:
		change_state(States.RUN)
	if state == States.RUN and velocity.x == 0:
		change_state(States.IDLE)
	if state in [States.IDLE, States.RUN] and !is_on_floor():
		print_debug("Falling!")
		change_state(States.JUMP)

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state(States.IDLE)

func change_state(new_state):
	### TODO: Check if the transition is valid
	state = new_state
	match state:
		States.IDLE:
			new_anim = 'idle'
		States.RUN:
			new_anim = 'run'
		States.HURT:
			new_anim = 'hurt'
		States.JUMP:
			new_anim = 'jump_up'
		States.DEAD:
			hide()
	

func _physics_process(delta):
	# Force the character to the ground
	velocity.y += gravity*delta
	get_input()
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
	# Move the player
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if state == States.JUMP and velocity.y > 0:
		new_anim = 'jump_down'
	if state == States.JUMP and is_on_floor():
		change_state(States.IDLE)
	

func start(pos):
	position = pos
	show()
	change_state(States.IDLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#	pass