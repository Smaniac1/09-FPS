extends Spatial

var enemy_health = 0
var damage = 2.5
var time_left_light_timer = 10
var time_since_light_off = 0
var light_disabled = false
var score = 0
onready var hit_detection = $Area/CollisionShape

func _physics_process(delta):
	print(score)
	if not $Light_Timer.is_stopped():
		time_left_light_timer = $Light_Timer.get_time_left()


func _on_Area_body_entered(body):
	if (body.name == "Ghost"):
		$Damage_Timer.set_wait_time(.1)
		$Damage_Timer.set_one_shot(true)
		$Damage_Timer.start()
		body.take_damage(damage)
		enemy_health = body.health
		if enemy_health <= 0:
			score += 10
	else:
		for i in 1000:
			if (body.name == "@Ghost@" + str(i)):
				$Damage_Timer.set_wait_time(.1)
				$Damage_Timer.set_one_shot(true)
				$Damage_Timer.start()
				body.take_damage(damage)
				enemy_health = body.health



func _on_Damage_Timer_timeout():
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		if (body.name == "Ghost"):
			$Damage_Timer.set_wait_time(.1)
			$Damage_Timer.set_one_shot(true)
			$Damage_Timer.start()
			body.take_damage(damage)
			enemy_health = body.health
		else:
			for i in 1000:
				if (body.name == "@Ghost@" + str(i)):
					$Damage_Timer.set_wait_time(.1)
					$Damage_Timer.set_one_shot(true)
					$Damage_Timer.start()
					body.take_damage(damage)
					enemy_health = body.health


func _on_Light_Timer_timeout():
	hit_detection.set_disabled()
	$SpotLight.set_process(false)
	$Light_Disable.set_wait_time(5)
	$Light_Disable.set_one_shot(true)
	$Light_Disable.start()
	light_disabled = true
	$Light_Recharge.set_wait_time(.001)
	$Light_Recharge.set_one_Shot(true)
	$Light_Recharge.start()


func _on_Light_recharge_timeout():
	time_since_light_off = .01
	time_left_light_timer += time_since_light_off
	if time_left_light_timer > 10:
		time_left_light_timer = 10
	$Light_Recharge.set_wait_time(.01)
	$Light_Recharge.set_one_Shot(true)
	$Light_Recharge.start()


func _on_Light_Disable_timeout():
	light_disabled = false
