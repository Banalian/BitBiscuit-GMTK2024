class_name OrderManager
extends Node

signal order_completed

@export var root_node: Node

var _current_order: Array[Mix] = []
var _client_tiles: Array[ClientTile] = []

func _ready() -> void:
	_get_all_client_tiles()
	_connect_client_tile_signal()
	pass


func setup_order(mixes: Array):
	_current_order = mixes
	pass


func check_orders_state():
	var order_done:= true
	for order in _current_order:
		for client_tile in _client_tiles:
			var mix: Mix = client_tile.client_mix
			if not mix or not mix.equals(order):
				order_done = false
	if order_done:
		order_completed.emit()

func _on_mix_changed(mix: Mix):
	check_orders_state()


func _connect_client_tile_signal():
	for clientTile in _client_tiles:
		clientTile.connect("client_mix_changed", _on_mix_changed)


func _get_all_client_tiles():
	_client_tiles = []
	for child in root_node.get_children():
		if child is ClientTile:
			_client_tiles.append(child as ClientTile)
