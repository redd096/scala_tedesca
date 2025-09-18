class_name CardController extends Control

@export var card_data: Card
@export var show_front: bool = true

# Front and Back
@export var card_front: Control
@export var card_back: Control
@export var front_image: TextureRect
@export var back_image: TextureRect

# Front side elements
@export var top_left_label: Label
@export var bottom_right_label: Label

func _ready():
	update_card_display()

## Set new card data and update display
func set_card_data(new_card_data: Card):
	card_data = new_card_data
	update_card_display()

## Show front or back of the card
func set_show_front(value: bool):
	show_front = value
	card_front.visible = show_front
	card_back.visible = not show_front

## Update card display based on card data
func update_card_display():
	if not card_data:
		return
	
	# Set card images if available
	front_image.texture = card_data.front_image if card_data.front_image else null
	back_image.texture = card_data.back_image if card_data.back_image else null
	
	# Update front side labels
	var display_name = card_data.get_display_name()
	top_left_label.text = display_name
	bottom_right_label.text = display_name
	
	# Set colors based on suit
	var color = card_data.get_display_color()
	top_left_label.modulate = color
	bottom_right_label.modulate = color

## Toggle show front or back
func flip_card():
	set_show_front(not show_front)
