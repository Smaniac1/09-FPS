extends Spatial

var enemy_health = 0
var damage = 2.5
var time_left_light_timer = 10
var time_since_light_off = 0
var disabled = false
var recharging = false
var on = true
var score = 0
onready var hit_detection = $Area/CollisionShape

func _physics_process(delta):
	if not $Light_Timer.is_stopped():
		time_left_light_timer = $Light_Timer.get_time_left()

func a_minute_has_passed():
	score += 100


func turn_on():
	if not disabled and not on:
		on = true
		hit_detection.set_disabled(false)
		$SpotLight.show()
		$Light_Timer.set_wait_time(time_left_light_timer)
		$Light_Timer.set_one_shot(true)
		$Light_Timer.start()
		$Light_Recharge.stop()
		

func turn_off():
	if not disabled and on:
		on = false
		$SpotLight.hide()
		time_left_light_timer = $Light_Timer.get_time_left()
		$Light_Timer.stop()
		hit_detection.set_disabled(true)
		$Light_Recharge.set_wait_time(.01)
		$Light_Recharge.set_one_shot(true)
		$Light_Recharge.start()
	
func disable():
	turn_off()
	disabled = true
	$Light_Disable.set_wait_time(5)
	$Light_Disable.set_one_shot(true)
	$Light_Disable.start()
	$Light_Recharge.set_wait_time(.001)
	$Light_Recharge.set_one_shot(true)
	$Light_Recharge.start()

func enable():
	disabled = false

func do_damage(body):
	$Damage_Timer.set_wait_time(.1)
	$Damage_Timer.set_one_shot(true)
	$Damage_Timer.start()
	body.take_damage(damage)
	enemy_health = body.health
	if body.health <= 0:
		score += 10
	

func _on_Area_body_entered(body):
	if body.name.left(5) == "Ghost":
		do_damage(body)



func _on_Damage_Timer_timeout():
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		if body.name.left(5) == "Ghost":
			do_damage(body)
					


func _on_Light_Timer_timeout():
	disable()

func _on_Light_recharge_timeout():
	time_since_light_off = .01
	time_left_light_timer += time_since_light_off
	if time_left_light_timer > 10:
		time_left_light_timer = 10
	$Light_Recharge.set_wait_time(.01)
	$Light_Recharge.set_one_shot(true)
	$Light_Recharge.start()


func _on_Light_Disable_timeout():
	enable()
