extends EasyLANNetworkManager

signal update_servers_list
signal connection_ok
signal connection_error
signal disconnected

var server_codes : Dictionary
var server_ip : String

func setup() -> void:
	.setup()

	server_codes = {}

	enet_network.set_target_peer(NetworkedMultiplayerENet.TARGET_PEER_SERVER)
	set_process(true)
	_start_client()

func connect_to_server_code(code : String) -> bool :
	if (server_codes.has(code)):
		server_ip = server_codes[code]
		_start_enet_client()
		return true
	return false

func _start_enet_client():
	udp_network.close()
	set_process(false)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
# warning-ignore:return_value_discarded
	enet_network.create_client(server_ip, server_enet_port)
	get_tree().set_network_peer(enet_network)

func _start_client():
	if udp_network.listen(server_udp_port) != OK:
		printt("Error listening on port: " + str(server_udp_port))
	else:
		printt("Listening on port: " + str(server_udp_port))

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if udp_network.get_available_packet_count() > 0 and server_ip.empty():
		var array_bytes = udp_network.get_packet()
		var server_code = array_bytes.get_string_from_ascii()
		if not server_codes.has(server_code):
			server_codes[server_code] = udp_network.get_packet_ip()
			emit_signal("update_servers_list")
			printt("Received server code: ", server_code)

# TODO: Lifetime for server codes

func _connected_ok():
	emit_signal("connection_ok")

func _connected_fail():
	emit_signal("connection_error")

func _server_disconnected():
	emit_signal("disconnected")

func _ready() -> void:
	set_process(false)

#warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_connected_ok")
#warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_connected_fail")
#warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _exit_tree() -> void:
	udp_network.close()
