extends Node

signal failed_state(failed_round: Round, failed_round_number: int, final_score:int)
signal started_round(round: Round, round_number: int)
signal ended_round(round: Round, round_number: int)

@onready var game_timer: GameTimer = $CanvasLayer/GameTimer
@onready var end_round_timer: Timer = $EndRoundTimer
@onready var end_order_timer: Timer = $EndOrderTimer
@onready var start_order_timer: Timer = $StartOrderTimer
@onready var start_game_timer: Timer = $StartGameTimer
@onready var order_generator: OrderGenerator = $OrderGenerator
@onready var order_manager: OrderManager= $OrderManager
@onready var order_num_label: RichTextLabel = $CanvasLayer/OrderNumLabel
@export var client: Main

@onready var main = $".."


class Round:
	# Allowed time in second to complete the minimum quota for the round
	var allowed_time: float
	# Minimum amount of order required to complete the Round
	var order_quota: int
	
	func _init(p_allowed_time:= 45.0, p_order_quota:= 2):
		allowed_time = p_allowed_time
		order_quota = p_order_quota

var rounds: Array[Round] = []

# Keep track of if the player is doing the round, or is in_between
var _in_round:= false
var _current_round:= 0
var _completed_order:= 0
var _total_completed_order:= 0

#Use to transfer the orders between the order starting (client coming) and it really starting
var _tmp_order: Array[Mix]


func _init() -> void:
	# UGLY, but do the data init for the rounds here
	var testRound = Round.new(120.0)
	var round1 = Round.new(80.0, 5)
	var round2 = Round.new(80.0, 10)
	rounds.append(testRound)
	rounds.append(round1)
	rounds.append(round2)


func _ready() -> void:
	start_game_timer.start()


func _process(_delta: float) -> void:
	_update_label()


func start_round(new_round: Round):
	_completed_order = 0
	_in_round = true
	game_timer.stop_timer()
	game_timer.start_timer(new_round.allowed_time)
	var mixes = order_generator.generate_mixes()
	_tmp_order = mixes
	game_timer.pause_timer()
	start_order_timer.start(client.start_client(mixes))
	started_round.emit(rounds[_current_round], _completed_order)


func end_round():
	ended_round.emit(rounds[_current_round], _completed_order)
	_in_round = false
	if client.view_shift:
			client.view_shift = false
			client.camera_base.position.y = 0.0
	order_manager.clear_order()
	if _completed_order < rounds[_current_round].order_quota:
		print("not enough orders")
		main.audio_stream_game.stream = load("res://Assets/Sounds/LoseFanfare.mp3")
		main.audio_stream_game.pitch_scale = 0.8 + (randi() % 11) / 25.0
		main.audio_stream_game.play()
		failed_state.emit(rounds[_current_round], _current_round, _total_completed_order)
		return
	else:
		main.audio_stream_game.stream = load("res://Assets/Sounds/WinFanfare.mp3")
		main.audio_stream_game.pitch_scale = 0.8 + (randi() % 11) / 25.0
		main.audio_stream_game.play()
	_current_round += 1
	if rounds.size() <= _current_round:
		# Do something about not having enough round
		generate_additional_round()
	# Start end round timer
	end_round_timer.start()


func generate_additional_round():
	# take last order, add X quota and X seconds, hopefully making it impossible at some point
	var old_round := rounds[rounds.size() - 1]
	var new_time := old_round.allowed_time + 5.0
	var new_quota := old_round.order_quota + 3
	rounds.append(Round.new(new_time, new_quota))


func _update_label():
	if _current_round >= rounds.size():
		return
	if _completed_order < rounds[_current_round].order_quota:
		order_num_label.text = "Quota: " + str(rounds[_current_round].order_quota - _completed_order) + " order(s) left"
	else:
		order_num_label.text = "Quota Achieved!\nBonus order(s): " + str(_completed_order - rounds[_current_round].order_quota)

func _on_order_completed():
	main.audio_stream_game.stream = load("res://Assets/Sounds/CompletedOrder.mp3")
	main.audio_stream_game.pitch_scale = 0.8 + (randi() % 11) / 25.0
	main.audio_stream_game.play()
	_completed_order += 1
	_total_completed_order += 1
	order_manager.clear_order()
	game_timer.pause_timer()
	end_order_timer.start(client.end_client())

# game timer ended, time to start ending the round
func _on_timer_end():
	end_round()

# Start a new order in the round
func _on_end_order_timer_timeout() -> void:
	if _current_round == 0 and _completed_order >= rounds[0].order_quota:
		# Special case to stop the tuto round early
		end_round()
		return
	var mixes = order_generator.generate_mixes()
	_tmp_order = mixes
	start_order_timer.start(client.start_client(mixes))

func _start_actual_order() -> void:
	if _tmp_order.size() >= 1:
		order_manager.setup_order(_tmp_order)
		game_timer.resume_timer()
		_tmp_order = []

# round end timer
func _on_wait_timer_end():
	if not _in_round:
		start_round(rounds[_current_round])


func _on_start_game_timer_timeout() -> void:
	start_round(rounds[_current_round])
