extends Node2D

var current_player

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed()):
		current_player.rpc("change_position", event.position)

func _ready():
	var peer = get_tree().network_peer
	var ids = get_tree().root.get_node("GameNetworkSync").players_ids
	
	var player_scene = load("res://scenes/Player.tscn")
	for id in ids:
		var player = player_scene.instance()
		player.name = str(id)
		add_child(player)
		if (id == get_tree().get_network_unique_id()):
			current_player = player
