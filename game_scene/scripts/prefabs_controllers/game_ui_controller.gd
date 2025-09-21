class_name GameUIController extends Node

## Prefab to show a CardData in scene as a CardController
@export var card_prefab: PackedScene
## Container to show the deck
@export var deck_container: Control
## Prefab of PlayerCardsController
@export var player_cards_prefab: PackedScene
## Instantiate PlayerCardsController in the 4 containers to show 4 players
@export var players_containers: Array[Control]
@export var start_animation_delay_between_cards: float = 0.1

## Key: Card data, value: CardController in scene
var cards_in_scene: Dictionary[Card, CardController]
## Key: player index, value: PlayerCardsController in scene
var players_in_scene: Dictionary[int, PlayerCardsController]

## Instantiate every card in deck
func instantiate_deck_cards(deck: Deck):
	for card_data in deck.cards:
		var card_ui : CardController = card_prefab.instantiate()
		card_ui.set_card_data(card_data)
		cards_in_scene[card_data] = card_ui
		deck_container.add_child.call_deferred(card_ui)

## Instantiate every player in scene
func instantiate_players(players_count: int):
	# Player 1 always at the bottom
	_instantiate_player(0, players_containers[0])
	# Calculate the opponent on the top:
	# 1 opponent put index 0 at top; 2 opponents index 1 at top (0 at left); 3 opponents index 1 at top (0 at left and 2 at right); 4 opponents index 2 at top (0, 1 at left and 3 at right), etc...
	var opponents_count : int = players_count - 1
	var top_opponent_index : int = floori(opponents_count / 2.0)
	# Instantiate players at the left
	for i in range(1, top_opponent_index):
		_instantiate_player(i, players_containers[1])
	# Instantiate top player
	_instantiate_player(top_opponent_index, players_containers[2])
	# Instantiate players at the right
	for i in range(top_opponent_index + 1, players_count):
		_instantiate_player(i, players_containers[3])

func _instantiate_player(player_index: int, player_container: Control):
	var player_ui : PlayerCardsController = player_cards_prefab.instantiate()
	player_ui.set_player_name(str("Player ", player_index + 1))
	player_container.add_child.call_deferred(player_ui)
	players_in_scene[player_index] = player_ui

## Set player turns
func set_player_turn(player_index: int):
	for index in players_in_scene.keys():
		players_in_scene[index].set_turn(index == player_index)

## Add cards in hand and pozzetto for this player
func set_player_cards(player_index: int, hand_cards: Array[Card], pozzetto_cards: Array[Card]) -> Tween:
	var tween : Tween = get_tree().create_tween()
	var delay = 0.0	
	# Animate hand cards
	for card_data in hand_cards:
		_animate_card_to_player(card_data, player_index, true, delay, tween)
		delay += start_animation_delay_between_cards	
	# Animate pozzetto cards
	for card in pozzetto_cards:
		_animate_card_to_player(card, player_index, false, delay, tween)
		delay += start_animation_delay_between_cards
	return tween

## Helper function to animate a card from deck to player
func _animate_card_to_player(card: Card, player_index: int, is_hand_card: bool, delay: float, tween: Tween):
	var card_ui : CardController = cards_in_scene[card]
	var player_ui = players_in_scene[player_index]
	
	# Store starting position
	var start_pos = card_ui.global_position
	
	# Move card to target container and get final position
	deck_container.remove_child(card_ui)
	if is_hand_card:
		player_ui.add_hand_card(card_ui)
	else:
		player_ui.add_pozzetto_card(card_ui)
	
	var end_pos = card_ui.global_position
	
	# Reset to starting position for animation
	card_ui.global_position = start_pos
	
	# Create tween for this card
	tween.parallel().tween_property(card_ui, "global_position", end_pos, 0.3).set_delay(delay)
	tween.parallel().tween_property(card_ui, "scale", Vector2.ONE, 0.3).set_delay(delay)
		