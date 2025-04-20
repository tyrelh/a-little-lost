extends Node

const INFO: int = 1
const WARN: int = 2
const ERROR: int = 3
const DEBUG: int = 0

const PREFIX: int = 0
const COLOR: int = 1

var LEVELS := {
	INFO: {
		PREFIX: "INFO",
		COLOR: "green"
	},
	WARN: {
		PREFIX: "WARN",
		COLOR: "yellow"
	},
	ERROR: {
		PREFIX: "ERROR",
		COLOR: "red"
	},
	DEBUG: {
		PREFIX: "DEBUG",
		COLOR: "white"
	}
}

func info(msg: String) -> void:
	if Constants.DEBUG:
		_emit_log(msg, LEVELS[INFO])

func warn(msg: String) -> void:
	if Constants.DEBUG:
		_emit_log(msg, LEVELS[WARN])

func debug(msg: String) -> void:
	if Constants.DEBUG:
		_emit_log(msg, LEVELS[DEBUG])

func error(msg: String) -> void:
	_emit_log(msg, LEVELS[ERROR])

func _emit_log(msg: String, level: Dictionary) -> bool:
	var log: String = "LEVEL: %s , LOCATION: %s , MESSAGE: [b]%s[/b]" % [level[PREFIX], _get_location(), msg]
	var formatedLog: String = "[color=%s]%s[/color]" % [level[COLOR], log]
	print_rich(formatedLog)
	return true

func _get_location() -> String:
	var caller: Dictionary = get_stack()[-1]
	var callerFile: String = caller["source"].lstrip("res://").split("/")[-1]
	var traceStatement: String = "%s.%s():%s" % [callerFile, caller["function"], caller["line"]]
	return traceStatement
