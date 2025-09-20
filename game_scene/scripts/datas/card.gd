class_name Card extends Resource

# Enum and Consts
enum ESeed { HEARTS, DIAMONDS, CLUBS, SPADES }
const JOLLY: int = 0
const ACE: int = 1
const JACK: int = 11
const QUEEN: int = 12
const KING: int = 13

@export var card_name: String
@export var card_seed: ESeed
## 1-13 for normal cards, 0 for jolly
@export var card_number: int
@export var front_image: Texture2D
@export var back_image: Texture2D

## Check if card can be used in sequence at position
func can_follow_in_sequence(other_card: Card, king_is_jolly: bool) -> bool:
	# Jolly
	if card_number == JOLLY or other_card.card_number == JOLLY:
		return true
	# Kings as jolly
	if king_is_jolly and (card_number == KING or other_card.card_number == KING):
		return true
	# Different seed
	if card_seed != other_card.card_seed:
		return false
	# Normal sequence
	return card_number - other_card.card_number == 1
	# return abs(card_number - other_card.card_number) == 1

## Get display name
func get_display_name() -> String:
	if card_number == JOLLY:
		return "Joker"
	
	var base_name: String
	match card_number:
		ACE: base_name = "A"
		JACK: base_name = "J"
		QUEEN: base_name = "Q"
		KING: base_name = "K"
		_: base_name = str(card_number)
	
	var symbol: String
	match card_seed:
		ESeed.HEARTS: symbol = "♥"
		ESeed.DIAMONDS: symbol = "♦"
		ESeed.CLUBS: symbol = "♣"
		ESeed.SPADES: symbol = "♠"
	
	return base_name + symbol

## Get display color
func get_display_color() -> Color:
	# if card_number == JOLLY:
	# 	return Color.GREEN_YELLOW
	
	if card_seed == ESeed.HEARTS or card_seed == ESeed.DIAMONDS:
		return Color.RED
	
	return Color.BLUE
