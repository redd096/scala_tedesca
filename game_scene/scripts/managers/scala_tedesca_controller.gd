class_name ScalaTedescaController extends Control

# Scene references for the card scene
@export var card_scene: PackedScene = preload("res://card_scene/card.tscn")

# Node references
@onready var draw_deck_container: HBoxContainer = $MainContainer/TopArea/DrawDeckArea/DrawDeck
@onready var discard_deck_container: HBoxContainer = $MainContainer/TopArea/DiscardDeckArea/DiscardDeck
@onready var opponent_cards_container: HBoxContainer = $MainContainer/TopArea/OpponentCardsArea/OpponentCards
@onready var left_opponent_container: VBoxContainer = $MainContainer/MiddleArea/LeftOpponentArea/LeftOpponentCards
@onready var right_opponent_container: VBoxContainer = $MainContainer/MiddleArea/RightOpponentArea/RightOpponentCards
@onready var play_area_flow: HFlowContainer = $MainContainer/MiddleArea/PlayArea/PlayAreaBackground/PlayAreaFlow
@onready var player_hand_container: HBoxContainer = $MainContainer/BottomArea/PlayerHandArea/PlayerHand
@onready var pozzetto_container: HBoxContainer = $MainContainer/BottomArea/PozzettoArea/Pozzetto

# Game data
var deck: Deck
var discard_pile: Array[Card] = []
var player_hand: Array[Card] = []
var pozzetto: Array[Card] = []
var play_sequences: Array[Array] = [] # Array of card sequences

func _ready():
	setup_game()

func setup_game():
	# Create and shuffle deck
	deck = Deck.new()
	deck._editor_create_full_deck()
	deck.shuffle()
	
	# Deal initial cards
	deal_initial_cards()
	
	# Setup UI
	update_all_displays()

func deal_initial_cards():
	# Each player gets 11 cards initially
	for i in range(11):
		var card = deck.draw_card()
		if card:
			player_hand.append(card)
	
	# Put one card in pozzetto (face up)
	var pozzetto_card = deck.draw_card()
	if pozzetto_card:
		pozzetto.append(pozzetto_card)

func update_all_displays():
	update_draw_deck_display()
	update_discard_pile_display()
	update_player_hand_display()
	update_pozzetto_display()
	update_opponent_displays()
	update_play_area_display()

func update_draw_deck_display():
	# Clear existing cards
	for child in draw_deck_container.get_children():
		child.queue_free()
	
	# Show card backs for deck (use a simple container for stacking effect)
	if deck.size() > 0:
		var deck_stack = Control.new()
		deck_stack.custom_minimum_size = Vector2(60, 90)
		
		# Add multiple card backs with slight offset for depth
		for i in range(min(3, deck.size())):
			var card_control = create_card_display(null, false)
			card_control.position = Vector2(i * 2, i * 2)
			deck_stack.add_child(card_control)
		
		draw_deck_container.add_child(deck_stack)

func update_discard_pile_display():
	# Clear existing cards
	for child in discard_deck_container.get_children():
		child.queue_free()
	
	# Show top card of discard pile (face up)
	if discard_pile.size() > 0:
		var top_card = discard_pile[-1]
		var card_control = create_card_display(top_card, true)
		discard_deck_container.add_child(card_control)

func update_player_hand_display():
	# Clear existing cards
	for child in player_hand_container.get_children():
		child.queue_free()
	
	# Show player's cards (face up)
	for card in player_hand:
		var card_control = create_card_display(card, true)
		player_hand_container.add_child(card_control)

func update_pozzetto_display():
	# Clear existing cards
	for child in pozzetto_container.get_children():
		child.queue_free()
	
	# Show pozzetto cards
	for i in range(pozzetto.size()):
		var card = pozzetto[i]
		var show_front = (i == 0) # First card is face up, others face down
		var card_control = create_card_display(card, show_front)
		pozzetto_container.add_child(card_control)

func update_opponent_displays():
	# Update top opponent (show card backs)
	update_opponent_container(opponent_cards_container, 7, false)
	
	# Update left opponent (show card backs vertically)
	update_opponent_container(left_opponent_container, 5, false)
	
	# Update right opponent (show card backs vertically)
	update_opponent_container(right_opponent_container, 6, false)

func update_opponent_container(container: Container, card_count: int, show_front: bool):
	# Clear existing cards
	for child in container.get_children():
		child.queue_free()
	
	# Add card backs to represent opponent cards
	for i in range(card_count):
		var card_control = create_card_display(null, show_front)
		container.add_child(card_control)

func update_play_area_display():
	# Clear existing sequences
	for child in play_area_flow.get_children():
		child.queue_free()
	
	# Display each sequence as a group
	for sequence in play_sequences:
		var sequence_container = HBoxContainer.new()
		sequence_container.add_theme_constant_override("separation", 2)
		for card in sequence:
			var card_control = create_card_display(card, true)
			sequence_container.add_child(card_control)
		play_area_flow.add_child(sequence_container)

func create_card_display(card_data: Card, show_front: bool) -> CardController:
	var card_instance = card_scene.instantiate() as CardController
	if card_data:
		card_instance.set_card_data(card_data)
	card_instance.set_show_front(show_front)
	card_instance.custom_minimum_size = Vector2(60, 90) # Smaller size for game
	return card_instance

func add_sequence_to_play_area(cards: Array[Card]):
	play_sequences.append(cards)
	update_play_area_display()

func add_card_to_sequence(sequence_index: int, card: Card):
	if sequence_index < play_sequences.size():
		play_sequences[sequence_index].append(card)
		update_play_area_display()

# Example function to add some test sequences
func _input(event):
	if event.is_action_pressed("ui_accept"):
		# Add a test sequence for demonstration
		if player_hand.size() >= 3:
			var test_sequence = [player_hand[0], player_hand[1], player_hand[2]]
			for card in test_sequence:
				player_hand.erase(card)
			add_sequence_to_play_area(test_sequence)
			update_player_hand_display()
