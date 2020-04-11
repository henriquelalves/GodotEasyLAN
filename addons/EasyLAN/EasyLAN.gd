tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("EasyLANHost", "Node", preload("EasyLANHost.gd"), preload("host_icon.png"))
	add_custom_type("EasyLANClient", "Node", preload("EasyLANClient.gd"), preload("client_icon.png"))
	
func _exit_tree():
	remove_custom_type("EasyLANHost")
	remove_custom_type("EasyLANClient")
