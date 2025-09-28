extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var health = 60
var player_inattack_zone = false
var can_take_damage = true

func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		if position.distance_to(player.position) > 15:
			position+=(player.position-position)/speed
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true



func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack:
		if can_take_damage:
			health -= Global.max_strength / 4
			print("slime health is ", health)
			$take_damage_cooldown.start()
			can_take_damage = false
			if health <= 0:
				Global.soul_meter += 10
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
