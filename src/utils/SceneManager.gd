extends Node

var menu_scene: PackedScene = preload("res://src/scenes/game.tscn") # add menu later
var game_scene: PackedScene = preload("res://src/scenes/game.tscn")

signal exit_level
signal boss_defeated
