class_name PlayerTurnGameSceneState extends State

func _enter():
	var game_scene_manager : GameSceneManager = Singleton.instance(GameSceneManager)
	var ui_controller : GameUIController = game_scene_manager.ui_controller
	# Show player turn
	ui_controller.set_player_turn(game_scene_manager.player_turn_index)
