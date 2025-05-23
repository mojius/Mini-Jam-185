extends Node2D

@onready var labels_preload: PackedScene = preload("res://scenes/labels.tscn")
var labels: Control

var current_floor: int = 1

var score: int = 0

var time: float = 30

func _ready() -> void:
    labels = labels_preload.instantiate()
    add_child(labels)
