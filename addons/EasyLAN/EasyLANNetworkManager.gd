extends Node

class_name EasyLANNetworkManager

export(int) var server_udp_port = 1507
export(int) var server_enet_port = 1508

var udp_network : PacketPeerUDP
var enet_network : NetworkedMultiplayerENet

var player_list : Array

func setup() -> void:
	udp_network = PacketPeerUDP.new()
	enet_network = NetworkedMultiplayerENet.new()
