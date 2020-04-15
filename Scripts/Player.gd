extends KinematicBody

onready var Camera = $Pivot/Camera

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var health = 100
onready var spotlight = get_node("Pivot/Flash_Light/SpotLight")
onready var flashlight_hit_box = get_node("Pivot/Flash_Light/Area/CollisionShape")
onready var flashlight = get_node("Pivot/Flash_Light")
onready var light_timer = get_node("Pivot/Flash_Light/Light_Timer")
onready var light_recharge = get_node("Pivot/Flash_Light/Light_Recharge")

var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func take_damage(d):
	health -= d
	if health <= 0:
		die()

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("backward"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_just_pressed("light") and spotlight.show() == true:
		spotlight.hide()
		flashlight.time_left_light_timer = light_timer.get_time_left()
		light_timer.stop()
		flashlight_hit_box.set_disabled(true)
		light_recharge.set_wait_time(.01)
		light_recharge.set_one_Shot(true)
		light_recharge.start()
	if flashlight.light_disabled == false:
		if Input.is_action_just_released("light") and spotlight.hide() == true:
			flashlight_hit_box.set_disabled(false)
			spotlight.show()
			light_timer.set_wait_time(flashlight.time_left_light_timer)
			light_timer.set_one_shot(true)
			light_timer.start()
			light_recharge.stop()
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)


func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if translation.y < -100:
		die()

func die():
	get_tree().change_scene("res://Scenes/Lose.tscn")
