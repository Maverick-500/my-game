extends Window

func _ready():
	$VBoxContainer/health/health_sacrifice.pressed.connect(func(): _on_sacrifice("max_health"))
	$VBoxContainer/strength/strength_sacrifice.pressed.connect(func(): _on_sacrifice("max_strength"))
	$VBoxContainer/stamina/stamina_sacrifice.pressed.connect(func(): _on_sacrifice("max_stamina"))
	$VBoxContainer/speed/speed_sacrifice.pressed.connect(func(): _on_sacrifice("max_speed"))
	
	$VBoxContainer/convert.pressed.connect(func(): _on_convert_pressed())
	$VBoxContainer/close.pressed.connect(func(): _on_close_pressed())
	
	var target_stat_option = $VBoxContainer/target/target_stat_option
	target_stat_option.add_item("Health")
	target_stat_option.add_item("Strength")
	target_stat_option.add_item("Stamina")
	target_stat_option.add_item("Speed")

func open_menu():
	get_tree().paused = true
	popup_centered()
	update_ui()
	
func _on_close_pressed():
	hide()
	get_tree().paused = false

func update_ui():
	$VBoxContainer/health/health_bar.value = 100 * Global.max_health / Global.max_max_health
	$VBoxContainer/strength/strength_bar.value = 100 * Global.max_strength / Global.max_max_strength
	$VBoxContainer/stamina/stamina_bar.value = 100 * Global.max_stamina / Global.max_max_stamina
	$VBoxContainer/speed/speed_bar.value = 100 * Global.max_speed / Global.max_max_speed
	$VBoxContainer/soul/soul_bar.value = 100 * Global.soul_meter / Global.max_soul_meter

func _on_sacrifice(string):
	var amount = 20
	if Global.get(string) > amount:
		Global.set(string, Global.get(string) - amount)
		Global.soul_meter += amount / 2
	update_ui()

func _on_convert_pressed():
	var amount = int($VBoxContainer/amount/select_amount.value) * 10
	if Global.soul_meter < amount:
		return
	
	var index = $VBoxContainer/target/target_stat_option.selected
	var target = $VBoxContainer/target/target_stat_option.get_item_text(index)
	match target:
		"Health":
			Global.max_health += amount
		"Strength":
			Global.max_strength += amount
		"Stamina":
			Global.max_stamina += amount
		"Speed":
			Global.max_speed += amount
	Global.soul_meter -= amount
	update_ui()
