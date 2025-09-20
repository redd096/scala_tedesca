class_name GameSceneManager extends Node

## Deck used in scene
@export var deck: Deck
@export var rules: Rules
@export var number_of_players: int = 2
@export var ui_controller: GameUIController

## Deck of discarded cards
var discards_pile: Deck
## Key: player index, value: Array[Card]
var players_hands: Dictionary
## Key: player index, value: Array[Card]
var players_pozzetto: Dictionary
## Array of: Array[Card]. Every single array is a Scala on table, that contains an array of Card for that Scala
var cards_on_tabel: Array[Array]
## player turn
var player_turn_index: int

func _ready() -> void:
	## Set instance to use it, but we don't need it DontDestroyOnLoad
	var set_dont_destroy_on_load := false
	Singleton.check_instance(self, set_dont_destroy_on_load)
