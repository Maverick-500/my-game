extends AudioStreamPlayer2D

func _ready():
	finished.connect(_on_music_finished)  # no $ here!

func _on_music_finished():
	play()
