extends Node

signal failed_state(failed_round: Round, failed_round_number: int)
signal started_round(round: Round, round_number: int)
signal ended_round(round: Round, round_number: int)

@export var game_timer: GameTimer
@export var order_generator: OrderGenerator
@export var order_manager: OrderManager
@export var order_num_label: Label

class Round:
	# Allowed time in second to complete the minimum quota for the round
	var allowed_time:= 15.0
	# Minimum amount of order required to complete the Round
	var order_quota:= 2

var rounds: Array[Round] = []

# Keep track of if the player is doing the round, or is in_between
var _in_round:= false
var _current_round:= 0
var _completed_order:= 0
var _total_completed_order:= 0


func _init() -> void:
	var round1 = Round.new()
	var round2 = Round.new()
	round2.order_quota = 3
	rounds.append(round1)
	rounds.append(round2)
	rounds.append(Round.new())
	rounds.append(Round.new())


func _ready() -> void:
	start_round(rounds[_current_round])


func start_round(round: Round):
	_completed_order = 0
	_in_round = true
	game_timer.start_timer(round.allowed_time)
	var mixes = order_generator.generate_mixes()
	order_manager.setup_order(mixes)
	_update_label()
	started_round.emit(rounds[_current_round], _completed_order)


func end_round():
	ended_round.emit(rounds[_current_round], _completed_order)
	_in_round = false
	if _completed_order < rounds[_current_round].order_quota:
		failed_state.emit(rounds[_current_round], _completed_order)
		return
	_current_round += 1
	if rounds.size() < _current_round:
		#do something about not having enough round
		pass
	start_round(rounds[_current_round])


func _update_label():
	if _completed_order < rounds[_current_round].order_quota:
		order_num_label.text = "Quota: " + str(rounds[_current_round].order_quota - _completed_order) + " order(s) left"
	else:
		order_num_label.text = "Quota Achieved!\nBonus order(s): " + str(_completed_order - rounds[_current_round].order_quota)

func _on_order_completed():
	_completed_order += 1
	_total_completed_order += 1
	var mixes = order_generator.generate_mixes()
	order_manager.setup_order(mixes)
	_update_label()


func _on_timer_end():
	end_round()
