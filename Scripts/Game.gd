extends Spatial

var enemy_timer_length = 10
var spawn_increase = 540
var ghost_scene = load("res://Scenes/Ghost.tscn")
var i = 0

onready var enemy_health = $Player/Pivot/Flash_Light.enemy_health
onready var flashlight_time_left = $Player/Pivot/Flash_Light.time_left_light_timer
onready var time_left = $Game_Timer.get_time_left()
onready var player_health = $Player.health
onready var enemy_timer = $Enemies/Enemy_Spawn_Timer
onready var score = $Player/Pivot/Flash_Light.score

# warning-ignore:unused_argument
func _unhandled_input(event):
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func _on_Game_Timer_timeout():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Win.tscn")

# warning-ignore:unused_argument
func _physics_process(delta):
	enemy_health = $Player/Pivot/Flash_Light.enemy_health
	time_left = $Game_Timer.get_time_left()
	player_health = $Player.health
	flashlight_time_left = $Player/Pivot/Flash_Light.time_left_light_timer
	score = $Player/Pivot/Flash_Light.score
	$HUD/Time_Left.text = "Time Remaining: " + str(time_left)
	$HUD/Health.text = "Health: " + str(player_health)
	$HUD/Enemy_Health.text = "Enemy Health: " + str(enemy_health)
	$HUD/Flash_Light_Time.text = "Time Left on Flashlight: " + str(flashlight_time_left)
	$HUD/Score.text = "Score: " + str(score)

func _on_Enemy_Spawn_Timer_timeout():
	var ghost = ghost_scene.instance()
	randomize()
	var x = randi()%25+1
	if x == 1:
		ghost.translation.x = 100
		ghost.translation.z = 100
	if x == 2:
		ghost.translation.x = 100
		ghost.translation.z = 50
	if x == 3:
		ghost.translation.x = 100
		ghost.translation.z = 0
	if x == 4:
		ghost.translation.x = 100
		ghost.translation.z = -50
	if x == 5:
		ghost.translation.x = 100
		ghost.translation.z = -75
	if x == 6:
		ghost.translation.x = 50
		ghost.translation.z = 100
	if x == 7:
		ghost.translation.x = 50
		ghost.translation.z = 50
	if x == 8:
		ghost.translation.x = 50
		ghost.translation.z = 0
	if x == 9:
		ghost.translation.x = 50
		ghost.translation.z = -50
	if x == 10:
		ghost.translation.x = 50
		ghost.translation.z = -100
	if x == 11:
		ghost.translation.x = 0
		ghost.translation.z = 100
	if x == 12:
		ghost.translation.x = 0
		ghost.translation.z = 50
	if x == 13:
		ghost.translation.x = 0
		ghost.translation.z = 0
	if x == 14:
		ghost.translation.x = 0
		ghost.translation.z = -50
	if x == 15:
		ghost.translation.x = 0
		ghost.translation.z = -100
	if x == 16:
		ghost.translation.x = -50
		ghost.translation.z = 100
	if x == 17:
		ghost.translation.x = -50
		ghost.translation.z = 50
	if x == 18:
		ghost.translation.x = -50
		ghost.translation.z = 0
	if x == 19:
		ghost.translation.x = -50
		ghost.translation.z = -50
	if x == 20:
		ghost.translation.x = -50
		ghost.translation.z = -100
	if x == 21:
		ghost.translation.x = -100
		ghost.translation.z = 100
	if x == 22:
		ghost.translation.x = -100
		ghost.translation.z = 50
	if x == 23:
		ghost.translation.x = -100
		ghost.translation.z = 0
	if x == 24:
		ghost.translation.x = -100
		ghost.translation.z = -50
	if x == 25:
		ghost.translation.x = -100
		ghost.translation.z = -100
	if time_left <= spawn_increase:
		print("Speed UP")
		$Player/Pivot/Flash_Light.a_minute_has_passed()
		spawn_increase -= 60
		enemy_timer_length -= 1
	i += 1
	ghost.name = "Ghost" + str(i)
	$Enemies.add_child(ghost)
	$Enemies/Enemy_Spawn_Timer.set_wait_time(enemy_timer_length)
	$Enemies/Enemy_Spawn_Timer.set_one_shot(true)
	$Enemies/Enemy_Spawn_Timer.start()
