class_name GameSceneSM extends StateMachine

## States
@export var initialization_state: InitializationGameSceneState
@export var player_turn_state: PlayerTurnGameSceneState

func _ready():
	# Set first state
	set_state(initialization_state)
