class_name GameSceneManager extends Node

@export var rules: Rules
@export var ui_controller: ScalaTedescaController

func _ready() -> void:
	Singleton.check_instance(self)
