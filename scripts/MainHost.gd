extends Control

onready var GameRoomNameEntry = preload("res://scenes/GameRoomNameEntry.tscn")

var _game_network_sync

func _on_update_players_list():
	for child in $PlayersConnected/PlayerList.get_children():
		child.queue_free()

	for id in $EasyLANHost.players_connected:
		var new_entry = GameRoomNameEntry.instance()
		new_entry.setup(str(id), "")
		$PlayersConnected/PlayerList.add_child(new_entry)

func _on_start_button_pressed():
	$EasyLANHost.stop_broadcast()
	var ids = $EasyLANHost.players_connected
	ids.append(get_tree().get_network_unique_id())
	_game_network_sync.rpc("start_game", $EasyLANHost.players_connected)

func _ready():
	_game_network_sync = load("res://scenes/GameNetworkSync.tscn").instance()
	get_tree().root.add_child(_game_network_sync)
	
	$EasyLANHost.connect("update_players_list", self, "_on_update_players_list")
	$EasyLANHost.setup()
	$EasyLANHost.start_broadcast()
	
	$StartButton.connect("pressed", self, "_on_start_button_pressed")
