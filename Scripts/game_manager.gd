extends Node

@export var game_timer: GameTimer
@export var order_generator: OrderGenerator
@export var order_manager: OrderManager

class Round:
	# Allowed time in second to complete the minimum quota for the round
	var allowed_time:= 60.0
	# Minimum amount of order required to complete the Round
	var order_quota:= 10

var rounds:= []

# Keep track of if the player is doing the round, or is in_between
var _in_round:= false
var _completed_order:= 0


func _init() -> void:
	var round1 = Round.new()
	var round2 = Round.new()
	round2.order_quota = 15
	rounds.append(round1)
	rounds.append(round2)


func start_round(round: Round):
	_in_round = true
	game_timer.start_timer(round.allowed_time)
	var mixes = order_generator.generate_mixes()
	order_manager.setup_order(mixes)


func end_round():
	_in_round = false


func _on_order_completed():
	_completed_order = _completed_order + 1
	var mixes = order_generator.generate_mixes()
	order_manager.setup_order(mixes)


func _on_round_end():
	end_round()
