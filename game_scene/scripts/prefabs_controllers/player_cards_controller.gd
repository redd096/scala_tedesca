class_name PlayerCardsController extends Node

@export var name_label: Label
@export var turn_icon: TextureRect
@export var pozzetto_container: Control
@export_group("Cards in hand")
## When exceed this number of cards, use Overflow Container
@export var use_overflow_container : bool = true
@export var overflow_count: int = 10
@export_subgroup("Normal Container")
## Container to show a list of cards
@export var cards_container_obj: Control
@export var cards_container: Control
@export_subgroup("Overflow Container")
## Container to show just one card and a number of how many they are, when there are too many
@export var overflow_container_obj: Control
@export var overflow_counter_label: Label

## Cards currently in hand
var hand_cards: Array[CardController]
## Cards currently in pozzetto
var pozzetto_cards: Array[CardController]

## Set player name (and show or hide label)
func set_player_name(player_name: String):
	name_label.text = player_name
	name_label.visible = not player_name.is_empty()

## Show or hide turn icon
func set_turn(is_its_turn: bool):
	turn_icon.visible = is_its_turn

## Add card in hand
func add_hand_card(card_ui: CardController):
	# Add card to normal container
	cards_container.add_child.call_deferred(card_ui)
	hand_cards.append(card_ui)
	# and be sure to show correct container
	_show_correct_container()

## Remove card in hand
func remove_hand_card(card_ui: CardController):
	# Remove card from normal container
	cards_container.remove_child(card_ui)
	hand_cards.erase(card_ui)
	# and be sure to show correct container
	_show_correct_container()

## Add card in pozzetto
func add_pozzetto_card(card_ui: CardController):
	pozzetto_container.add_child(card_ui)
	pozzetto_cards.append(card_ui)

## Remove card in pozzetto
func remove_pozzetto_card(card_ui: CardController):
	pozzetto_container.remove_child(card_ui)
	pozzetto_cards.erase(card_ui)

## Show correct container (normal or overflow)
func _show_correct_container():
	# if exceed overflow, show overflow container, else show normal container
	var cards_count : int = hand_cards.size()
	var is_overflow : bool = use_overflow_container and cards_count > overflow_count
	cards_container_obj.visible = not is_overflow
	overflow_container_obj.visible = is_overflow
	overflow_counter_label.text = str(cards_count)

## Generate pozzetto in scene
func generate_pozzetto(cards_ui: Array[CardController]):
	for card_ui in cards_ui:
		add_hand_card(card_ui)
		pozzetto_cards.append(card_ui)