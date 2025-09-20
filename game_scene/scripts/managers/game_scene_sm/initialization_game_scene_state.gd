class_name InitializationGameSceneState extends State

func _enter() -> void:
	print(Singleton.instance(GameSceneManager))
