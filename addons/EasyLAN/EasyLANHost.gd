extends EasyLANNetworkManager

const UDP_BROADCAST_FREQUENCY = 0.5

signal player_connected(id)
signal player_disconnected
signal update_players_list

export(int) var max_players = 4
export(bool) var auto_broadcast = false

var server_code : String
var player_index : int

var broadcasting : bool
var players_connected : Array

var _broadcast_timer : float = 0

func setup():
	.setup()
	_start_server()
	
	server_code = ""
	for _i in range(4):
		server_code += char(97 + (randi() % 25))

	players_connected = []
	set_accept_connections(true)
	#warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	#warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	set_process(true)
	
	if (auto_broadcast):
		start_broadcast()

func start_broadcast():
	broadcasting = true

	if not udp_network.is_listening():
		if udp_network.listen(server_udp_port) != OK:
			printt("Error listening on port: " + str(server_udp_port))
		else:
			printt("Listening on port: " + str(server_udp_port))
		udp_network.set_broadcast_enabled(true)

func stop_broadcast():
	broadcasting = false
	udp_network.close()

func _start_server():
	var err = enet_network.create_server(server_enet_port, max_players)
	print("Create server status code: ", err)
	get_tree().set_network_peer(enet_network)

#warning-ignore:unused_argument
func _process(delta: float) -> void:
	_broadcast_timer -= delta
	if udp_network.is_listening() and broadcasting and _broadcast_timer <= 0:
		_broadcast_timer = UDP_BROADCAST_FREQUENCY
		#warning-ignore:return_value_discarded
		udp_network.set_dest_address("255.255.255.255", server_udp_port)
		var stg = server_code
		var pac = stg.to_ascii()
		#warning-ignore:return_value_discarded
		udp_network.put_packet(pac)

func set_accept_connections(is_accepting : bool):
	if is_accepting and players_connected.size() >= max_players - 1:
		get_tree().refuse_new_network_connections = true
	else:
		get_tree().refuse_new_network_connections = !is_accepting

func _player_connected(id):
	emit_signal("player_connected", id)
	players_connected.append(id)
	if players_connected.size() >= max_players - 1:
		set_accept_connections(false)
		if (auto_broadcast):
			stop_broadcast()
	emit_signal("update_players_list")

#warning-ignore:unused_argument
func _player_disconnected(id):
	emit_signal("player_disconnected")
	if (players_connected.has(id)):
		players_connected.erase(id)
		emit_signal("update_players_list")

func _ready() -> void:
	print("Ready1")
	set_process(false)

func _exit_tree() -> void:
	udp_network.close()
