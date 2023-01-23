extends Control

var is_paused = false setget set_is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = not is_paused


func _on_PlayBtn_pressed():
	self.is_paused = false


func _on_RestartBtn_pressed():
	self.is_paused = false
	get_tree().reload_current_scene()


func _on_ExitBtn_pressed():
	get_tree().quit()
