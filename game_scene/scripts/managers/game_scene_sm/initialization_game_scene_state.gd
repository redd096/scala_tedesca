class_name InitializationGameSceneState extends State

const START_DELAY: float = 1
const END_DELAY: float = 1

func _enter() -> void:
	var game_scene_manager : GameSceneManager = Singleton.instance(GameSceneManager)
	var ui_controller : GameUIController = game_scene_manager.ui_controller
	var deck = game_scene_manager.deck
	var number_of_players = game_scene_manager.number_of_players

	# Shuffle deck, create hand and pozzetto for every player
	deck.shuffle()
	for i in range(number_of_players):
		var player_hand = deck.draw_cards(13)
		var pozzetto = deck.draw_cards(13)
		game_scene_manager.players_hands[i] = player_hand
		game_scene_manager.players_pozzetto[i] = pozzetto
	
	# Instantiate datas in scene 
	ui_controller.instantiate_deck_cards(deck)
	ui_controller.instantiate_players(game_scene_manager.number_of_players)
	
	# Wait few seconds
	await get_tree().create_timer(START_DELAY).timeout

	# Then start animations to give player cards
	for i in range(number_of_players):
		await ui_controller.set_player_cards(i, game_scene_manager.players_hands[i], game_scene_manager.players_pozzetto[i]).finished

	## Wait other seconds and start game
	await get_tree().create_timer(END_DELAY).timeout
	state_machine.set_state(state_machine.player_turn_state)
