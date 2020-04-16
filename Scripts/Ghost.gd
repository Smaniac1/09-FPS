extends KinematicBody

var state = ""
var speed = 6
onready var Scan = $Area
var health = 100
var found = false
var velocity = Vector3()
var x = 0
var damage = 1.25
var player_position = Vector3()
var lastpos = Vector3()

onready var player = get_parent().get_parent().get_node("Player")

func take_damage(d):
	health -= d
	if health <= 0:
		queue_free()

func change_state(s):
	state = s
	if state == "scanning":
		pass
	if state == "found":
		pass

func _ready():
	change_state("searching")
	$Walk_Timer.start()

func _physics_process(delta):
	if found == false:
		change_state("searching")
	if found == true:
		change_state("found")
	if state == "searching":
		if x == 1:
			velocity = Vector3(5,0,0)
			rotation_degrees.y = 90
		if x == 2:
			velocity = Vector3(-5,0,0)
			rotation_degrees.y = 270
		if x == 3:
			velocity = Vector3(0,0,5)
			rotation_degrees.y = 0
		if x == 4:
			velocity = Vector3(0,0,-5)
			rotation_degrees.y = 180
		if x == 5:
			velocity = Vector3(5,0,5)
			rotation_degrees.y = 45
		if x == 6:
			velocity = Vector3(5,0,-5)
			rotation_degrees.y = 135
		if x == 7:
			velocity = Vector3(-5,0,-5)
			rotation_degrees.y = 225
		if x ==8:
			velocity = Vector3(-5,0,5)
			rotation_degrees.y = 315
		if (translation.x > 100) or (translation.x < -100):
			velocity.x *= -1
		if (translation.z > 100) or (translation.z < -100):
			velocity.z *= -1
		velocity = move_and_slide(velocity, Vector3.UP, true)
	if state == "found":
		look_at(-player.translation, Vector3(0,1,0))
		player_position = player.translation
		velocity = (player_position - translation).normalized()
		velocity = move_and_slide(velocity * speed, Vector3.UP, true)

func _on_Area_body_entered(body):
	if body.name == 'Player':
		found = true

func _on_Area_body_exited(body):
	if body.name == 'Player':
		found = false


func _on_Walk_Timer_timeout():
	randomize()
	x = randi()%8+1
	$Walk_Timer.set_wait_time(5)
	$Walk_Timer.set_one_shot(true)
	$Walk_Timer.start()

func _on_Attack_body_entered(body):
	if body.name == 'Player':
		$Damage_Timer.set_wait_time(.25)
		$Damage_Timer.set_one_shot(true)
		$Damage_Timer.start()
		body.take_damage(damage)


func _on_Damage_Timer_timeout():
	var bodies = $Attack.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$Damage_Timer.set_wait_time(.25)
			$Damage_Timer.set_one_shot(true)
			$Damage_Timer.start()
			body.take_damage(damage)
