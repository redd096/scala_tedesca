class_name GameSceneSM extends StateMachine

@export var initialization_state: InitializationGameSceneState

func _ready():
	# Set first state
	set_state(initialization_state)
