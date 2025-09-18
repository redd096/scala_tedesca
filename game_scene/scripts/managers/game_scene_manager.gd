class_name GameSceneManager extends Node

@export var rules: Rules

func _ready() -> void:
    Singleton.check_instance(self)