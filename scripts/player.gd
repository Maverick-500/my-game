extends CharacterBody2D

var max_stamina = 100
var stamina = max_stamina
var max_speed = 130
var speed = max_speed
var current_dir = "none"

@onready var stamina_bar = $TextureProgressBar
func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_ability(delta)
	player_movement(delta)
	

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
			speed = max_speed * 2
			stamina -= 80 * delta
		else:
			speed = max_speed
	else:
		speed = max_speed
		stamina = min(stamina + 30 * delta, max_stamina)
	stamina_bar.value = stamina

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
