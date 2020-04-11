extends Control

func _ready():
	$VBoxContainer/HostButton.connect("button_down", self, "_on_host_clicked")
	$VBoxContainer/JoinButton.connect("button_down", self, "_on_join_clicked")

func _on_host_clicked():
	get_tree().change_scene("res://scenes/MainHost.tscn")

func _on_join_clicked():
	get_tree().change_scene("res://scenes/MainClient.tscn")
