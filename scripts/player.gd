extends CharacterBody2D

var stamina = Global.max_stamina
var speed = Global.max_speed
var current_dir = "none"
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = Global.max_health
var player_alive = true
var attack_ip = false

@onready var stamina_bar = $TextureProgressBar
@onready var health_bar = $TextureProgressBar2
func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_ability(delta)
	player_movement(delta)
	enemy_attack()
	attack()
	health_bar.value = 100 * health / Global.max_health
	
	if health <= 0:
		player_alive = false
		health = 0
		print("You dead bro.")
		die()

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

func player_ability(delta):
	if Input.is_action_pressed("use_ability"):
		if stamina > 0:
			speed = Global.max_speed * 2
			stamina -= 80 * delta
		else:
			speed = Global.max_speed
	else:
		speed = Global.max_speed
		stamina = min(stamina + 30 * delta, Global.max_stamina)
	stamina_bar.value = 100 * stamina / Global.max_stamina

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("side_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("back_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if !attack_ip:
				anim.play("front_idle")

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 5
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("peck"):
		Global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_peck")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_peck")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_peck")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_peck")
			$deal_attack_timer.start()
			


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	health += 5
	Global.player_current_attack = false
	attack_ip = false

func die():
	reset_current_stats()
	var game = get_tree().current_scene
	if game.has_method("reload_room"):
		game.reload_room() # your Game.gd function
	else:
		get_tree().reload_current_scene()

func reset_current_stats():
	health = Global.max_health
	speed = Global.max_speed
	Global.soul_meter = 0
