extends Control

onready var GameRoomNameEntry = preload("res://scenes/GameRoomNameEntry.tscn")

var _game_network_sync

func _on_update_servers_list():
	for child in $Lobby/JoiningRoom/GameRoomList.get_children():
		child.queue_free()
	
	var keys = $EasyLANClient.server_codes.keys()
	for key in keys:
		var ip = $EasyLANClient.server_codes[key]
		var new_entry = GameRoomNameEntry.instance()
		new_entry.setup(ip, key)
		$Lobby/JoiningRoom/GameRoomList.add_child(new_entry)

func _on_connect_pressed():
	$EasyLANClient.connect_to_server_code($Lobby/HBoxContainer/LineEdit.text)

func _on_connection_ok():
	$Lobby.hide()
	$WaitingHost.show()

func _ready():
	_game_network_sync = load("res://scenes/GameNetworkSync.tscn").instance()
	get_tree().root.add_child(_game_network_sync)
	
	$EasyLANClient.setup()
	$EasyLANClient.connect("update_servers_list", self, "_on_update_servers_list")
	$EasyLANClient.connect("connection_ok", self, "_on_connection_ok")

	$Lobby/HBoxContainer/ConnectButton.connect("pressed", self, "_on_connect_pressed")
