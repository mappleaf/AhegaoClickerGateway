extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 1911


func _ready() -> void:
	ConnectToServer()


func ConnectToServer() -> void:
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("server_disconnected", self, "_on_server_disconnected")
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

func AuthenticatePlayer(username, password, peer_id) -> void:
	print("Sending out auth request...")
	rpc_id(1, "AuthenticatePlayer", username, password, peer_id)

remote func AuthenticationResults(result, peer_id) -> void:
	print("Results received")
	Gateway.ReturnLoginRequest(result, peer_id)


func _on_server_disconnected() -> void:
	print("Auth server is shut down")
	get_tree().quit()

func _on_connection_failed() -> void:
	print("Failed to connect to auth server")

func _on_connection_succeeded() -> void:
	print("Succesfully connected to auth server")
