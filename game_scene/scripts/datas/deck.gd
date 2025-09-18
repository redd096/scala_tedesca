@tool
class_name Deck extends Resource

# Godot already handle runtime resources to avoid edit them in the project
@export var cards: Array[Card] = []

# Button to show in inspector. Remember to add @tool on the top of the script.
# First string is the name, 
# second string is a texture from https://godot-editor-icons.github.io/
# then the var to set the function to call. It can also be lambda -> var lambda = func(): print("hello")
@export_tool_button("Create Full Deck", "Callable") 
var create_deck_button = _editor_create_full_deck

## Create a full Scala Tedesca deck (2 standard decks + 4 jokers = 108 cards). 
## This is used in editor to create a default deck
func _editor_create_full_deck():
	cards.clear()

	# Add two standard 52-card decks
	for deck_num in range(2):
		for suit in Card.ESeed.values():
			for number in range(1, 14): # 1-13
				var card :Card = Card.new()
				card.card_seed = suit
				card.card_number = number
				card.card_name = card.get_display_name()
				cards.append(card)

	# Add 4 jokers
	for i in range(4):
		var jolly := Card.new()
		jolly.card_number = Card.JOLLY
		jolly.card_name = jolly.get_display_name()
		cards.append(jolly)

## Shuffle deck cards
func shuffle():
	cards.shuffle()
	# # Alternative with Fisher-Yates shuffle algorithm
	# for i in range(cards.size() - 1, 0, -1):
	# 	var random_index: int = randi_range(0, i)
	# 	var temp := cards[random_index]
	# 	cards[i] = cards[random_index]
	# 	cards[random_index] = temp

## Get first card in the list or null if empty
func draw_card() -> Card:
	return cards.pop_front()

## Add card to the list
func add_card(card: Card):
	cards.append(card)

## Number of cards in the deck
func size() -> int:
	return cards.size()

## Is deck empty?
func is_empty() -> bool:
	return cards.is_empty()
