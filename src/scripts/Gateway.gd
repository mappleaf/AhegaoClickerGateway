extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1910
var max_players = 4095


func _ready() -> void:
	StartServer()

func _process(_delta) -> void:
	if !custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()


func StartServer() -> void:
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print("Gateway server started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")

remote func LoginRequest(username, password) -> void:
	print("Login request received")
	var peer_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.AuthenticatePlayer(username, password, peer_id)

func ReturnLoginRequest(result, peer_id, token) -> void:
	rpc_id(peer_id, "ReturnLoginRequest", result, token)
	network.disconnect_peer(peer_id)


func _peer_connected(peer_id) -> void:
	print("User " + str(peer_id) + " connected")

func _peer_disconnected(peer_id) -> void:
	print("User " + str(peer_id) + " disconnected")
