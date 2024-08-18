extends Node2D

const PERSONALITIES = ["normal", "hyper", "bored", "angry", "sleepy", "out_of_time"]

var tween_type = Tween.TRANS_LINEAR
var personality = "normal"
var dialogues = {
	"normal": {
		0: [["Hello."],
			["Hi."]],
		1: [["I will want a ", ", and a ", "."],
			["Get me a ", ", and a ", "."]],
		2: [["This is good."],
			["Tasteful."]],
		3: [["Goodbye."],
			["I will come again."]]
	},
	"hyper": {
		0: [["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]HELLOOO!!"],
			["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]HIIIII!!!"]],
		1: [["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]I WANT A ", " AND ONE ", " THANK YOU!!!"],
			["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]I AM CRAVING ", " AND A ", " RIGHT NOW!!"]],
		2: [["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]THIS IS DELICIOUS!!!!!"],
			["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]THIS IS INCREDIBLE!!!!"]],
		3: [["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]THANK YOU FOR THE FOOD, I GOTTA RUN!!"],
			["[tornado radius=2 freq=8][rainbow freq=0.5 sat=1.0]THIS WAS THE BEST!! THANK YOU BYE!!!!"]]
	},
	"bored": {
		0: [["hi..."],
			["..."]],
		1: [["one ", " and ", "..."],
			["a ", " and one ", "..."]],
		2: [["..."],
			["good..."]],
		3: [["thanks..."],
			["bye..."]]
	},
	"angry": {
		0: [["Hm."],
			["Disgusting."]],
		1: [["Give me a ", " and ", ", [shake][color=red]DON'T MAKE ME WAIT."],
			["One ", " and ", " [shake][color=red]NOW."]],
		2: [["[shake][color=red]Took you long enough."],
			["[shake][color=red]Horrible waiting time."]],
		3: [["[shake][color=red]Never again."],
			["[shake][color=red]What a waste of time."]]
	},
	"sleepy": {
		0: [["Hi- [wave]*yawn*[/wave] sorry..."],
			["This table looks so comfy to lay down on..."]],
		1: [["I want a- [wave]*yawn*[/wave] ", " and ", " please..."],
			["One pillow... wait, no, it's a ", " and one ", ", sorry for [wave]*yawn*[/wave] the confusion..."]],
		2: [["Already? I was just about to get comfy..."],
			["You should replace the chairs with beds... Oh, thank you for the food..."]],
		3: [["It was a dream- [wave]*yawn*[/wave] come true..."],
			["I would like to just lay down here and sleep..."]]
	},
	"out_of_time": {
		0: [["No time to talk."],
			["I am late so just go quickly."]],
		1: [["A ", " and a ", ", quick."],
			["One ", " and ", " for yesterday."]],
		2: [["Took your sweet time huh."],
			["Were you harvesting it yourself? You're so slow."]],
		3: [["Next time do it quicker, not that I'll be coming back anyway."],
			["How unpleasant."]]
	}
}

@onready var back = $Back
@onready var eyes = $Eyes
@onready var mouth = $Mouth
@onready var hat = $Hat


func randomize() -> void:
	back.frame = randi() % 8
	eyes.frame = randi() % 8
	mouth.frame = randi() % 8
	hat.frame = randi() % 8
	personality = PERSONALITIES.pick_random()


func get_dialogue(type : int, order := [null, null]):
	var text = ""
	var index = 0
	var variation = randi() % dialogues[personality][type].size()
	if dialogues[personality][type][variation].size() > 2:
		for i in dialogues[personality][type][variation]:
			text += str(i)
			if index < order.size():
				text += order[index]
				index += 1
		return text
	else:
		return dialogues[personality][type][variation][0]
