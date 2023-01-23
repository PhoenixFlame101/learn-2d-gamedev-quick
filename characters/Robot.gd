extends KinematicBody2D

export var speed = 200.0
export var jump_strength = 600.0
export var gravity = 40.0

var velocity = Vector2.ZERO
var initial_pos = Vector2.ZERO

func _ready():
	initial_pos = get_node(".").position

func _physics_process(_delta):
	var horizontal_direction = Input.get_action_strength("robot_right") - Input.get_action_raw_strength("robot_left")

	velocity.x = horizontal_direction * speed
	velocity.y += gravity

	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_jumping = velocity.y < 0 and not is_on_floor()
	var is_running = is_on_floor() and not is_zero_approx(velocity.x)
	
	if Input.is_action_just_pressed("robot_jump") and is_on_floor():
		velocity.y -= jump_strength

	if is_jumping:
		$AnimatedSprite.play("jump")
	elif is_falling:
		$AnimatedSprite.play("fall")
	elif is_running:
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.play("idle")

	velocity = move_and_slide(velocity, Vector2.UP)

func respawn():
	get_node(".").set_deferred("position", initial_pos)


func _on_Spikes_body_entered(body):
	if body == get_node("."):
		respawn()


func _on_Button_body_entered(_body):
	var green_platform = get_parent().get_node("GreenPlatform")
	var blue_platform = get_parent().get_node("BluePlatform")
	
	# Blue platform is infront
	if green_platform.z_index == 0:
		blue_platform.get_node("CollisionShape2D").set_deferred("disabled", true)
		green_platform.get_node("CollisionShape2D").set_deferred("disabled", false)

	# Green platform is infront
	elif green_platform.z_index == 1:
		blue_platform.get_node("CollisionShape2D").set_deferred("disabled", false)
		green_platform.get_node("CollisionShape2D").set_deferred("disabled", true)

	# Toggle which platform is infront
	green_platform.set_deferred("z_index", not green_platform.z_index)


func _on_Destroyer_for_holes_body_entered(body):
	if body == get_node("."):
		respawn()
