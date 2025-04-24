class_name BasicTextDebugger extends Node2D

@onready var debugText1: RichTextLabel = $DebugText1

func _ready() -> void:
	#debugText1.add_theme_font_size_override("normal_font_size", 6)
	debugText1.text = ""

func UpdateDebugText(value: String) -> void:
	debugText1.text = value
