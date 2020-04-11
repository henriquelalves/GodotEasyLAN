extends Node

var players_ids

remotesync func start_game(ids):
	get_tree().change_scene("res://scenes/Game.tscn")
	players_ids = ids
