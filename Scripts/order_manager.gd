class_name OrderManager
extends Node

signal order_completed

@export var root_node: Node
@export var mix_displayer1: MixDisplayer
@export var mix_displayer2: MixDisplayer

var _current_order: Array[Mix] = []
var _client_tiles: Array[ClientTile] = []
var _checking:= false

@onready var main = get_parent().get_parent()

func _ready() -> void:
	_get_all_client_tiles()
	_connect_client_tile_signal()
	pass


func setup_order(mixes: Array[Mix]):
	clear_client_tiles()
	_current_order = mixes
	setup_displayers()
	pass


func setup_displayers():
	mix_displayer1.clear_mix()
	mix_displayer2.clear_mix()
	if _current_order.size() >= 1 :
		mix_displayer1.set_mix(_current_order[0])
	if _current_order.size() >= 2 :
		mix_displayer2.set_mix(_current_order[1])


func check_orders_state():
	print("checking order state")
	_checking = true
	var correct_mix:= 0
	for order in _current_order:
		for client_tile in _client_tiles:
			var mix: Mix = client_tile.client_mix
			if mix and mix.equals(order):
				correct_mix += 1
	if correct_mix == _current_order.size():
		clear_client_tiles()
		order_completed.emit()
		if main.view_shift:
			main.view_shift = false
			main.camera_base.position.y = 0.0
	_checking = false


func clear_client_tiles():
	for client_tile in _client_tiles:
		client_tile.erase_mix()


func _on_mix_changed(_mix: Mix):
	if not _checking:
		# Prevents a stack overflow because somehow only sometimes we end up in a stack overflow when checking and clearing stuff
		check_orders_state()


func _connect_client_tile_signal():
	for clientTile in _client_tiles:
		clientTile.connect("client_mix_changed", _on_mix_changed)


func _get_all_client_tiles():
	_client_tiles = []
	for child in root_node.find_children("*", "ClientTile"):
		_client_tiles.append(child)
