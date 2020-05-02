# EasyLAN

*For more addons, check [my GitHub](https://github.com/henriquelalves) and [my itch.io](https://perons.itch.io/) page.*

This is a Godot Addon to easily connect devices on the same LAN network.

## How it works
This addon uses basic network setup by creating a 'Host' device that continuosly send UDP packets with it's own IP and a 'room password' for it's 'lobby'; the packet is sent to the 0.0.0.0 IP address of the router, which broadcast the packet to all devices connected on the same LAN. 'Client' devices will receive the packet and create a list of available hosts and their respective room passwords. When a Client connects to a Host, it uses the stored IP to create a connection using Godot high-level multiplayer API.  

## How to use
**This addon only works on routers that allows hairpinning**. This addon handles the creation and setup of Ǵodot's High-Level Multiplayer framework. The addon is composed of two nodes: a 'Host' node, and a 'Client' node. To connect different devices, you must setup a device to be a Host and the others to be Clients; after that, the Host has to *start_broadcast* to send to the Clients it's address information. A password is generated on the Host and sent to Clients, and should be visible to the players; to connect them, you should use *connect_to_server_code* on the Clients and use the password sent to the client as the argument (passwords are basically hashes of a Host IP Addresses dictionary). The Host should use *stop_broadcast* whenever it should stop sending the players its IP Address to start the game.

Basically:

0. *setup* on Host and Clients devices.
1. *start_broadcast* on Host device.
2. *connect_to_server_code* on Client device, using the hash received by the server code.
3. *stop_broadcast* on Host.

## Demo project
This repository is a simple demonstration in which you must choose whether you'll be 'Host' or 'Client'; then, it estabilishes connection using the Addon. After players are connected to the host, it can start the 'game' by clicking Start, which will transfer all players connected to the game to a simple scene that synchronizes players mouse-clicks to move their Godot Icon.
