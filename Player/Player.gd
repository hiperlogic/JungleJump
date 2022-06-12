extends KinematicBody2D

signal life_changed
signal dead

var life

export (int) var run_speed
export (int) var jump_speed
export (int) var gravity

enum States {IDLE, RUN, JUMP, HURT, DEAD}
var state
var anim
var new_anim
var velocity = Vector2()

var max_jumps = 2
var jump_count = 0

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

	if jump and state == States.JUMP and jump_count < max_jumps:
		new_anim = 'jump_up'
		velocity.y = jump_speed/1.5
		jump_count += 1

	# Jumping only when on floor (we now have double jumps here!)
	if jump and is_on_floor():
		change_state(States.JUMP)
		velocity.y = jump_speed
		
		
	# States Changes according to Status
	if state == States.IDLE and velocity.x != 0:
		change_state(States.RUN)
	if state == States.RUN and velocity.x == 0:
		change_state(States.IDLE)
	if state in [States.IDLE, States.RUN] and !is_on_floor():
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
			velocity.y = -200
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			emit_signal('life_changed', life)
			yield(get_tree().create_timer(0.5), 'timeout')
			change_state(States.IDLE)
			if life <=0:
				change_state(States.DEAD)
		States.JUMP:
			new_anim = 'jump_up'
			jump_count = 1
		States.DEAD:
			emit_signal("dead")
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
	if state == States.HURT:
		return
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == 'DangerTiles':
			hurt()
		if collision.collider.is_in_group('enemies'):
			var player_feet = (position + $CollisionShape2D.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = -200
			else:
				hurt()
	if state == States.JUMP and velocity.y > 0:
		new_anim = 'jump_down'
	if state == States.JUMP and is_on_floor():
		change_state(States.IDLE)
	if position.y > 1000:
		change_state(States.DEAD)
	

func start(pos):
	position = pos
	life = 3
	emit_signal('life_changed', life)
	show()
	change_state(States.IDLE)

func hurt():
	if state != States.HURT:
		change_state(States.HURT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#	pass
