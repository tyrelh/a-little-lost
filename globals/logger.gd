extends Node

const INFO_PREFIX :=  "INFO: "
const WARN_PREFIX :=  "WARN: "
const ERROR_PREFIX := "ERROR:"
const DEBUG_PREFIX := "DEBUG:"

const INFO: int = 1
const WARN: int = 2
const ERROR: int = 3
const DEBUG: int = 0

const PREFIX: int = 0
const COLOR: int = 1

var LEVELS := {
	INFO: {
		PREFIX: "INFO: ",
		COLOR: "green"
	},
	WARN: {
		PREFIX: "WARN: ",
		COLOR: "yellow"
	},
	ERROR: {
		PREFIX: "ERROR: ",
		COLOR: "red"
	},
	DEBUG: {
		PREFIX: "DEBUG: ",
		COLOR: "white"
	}
}
var regex: RegEx

func _ready() -> void:
	regex = RegEx.new()
	regex.compile("\\/(?<className>\\w+)\\.(?<extension>\\w+)$")

func info(msg: String, location: String) -> void:
	if Constants.DEBUG:
		_emit_log(msg, location, LEVELS[INFO])

func warn(msg: String, location: String) -> void:
	if Constants.DEBUG:
		_emit_log(msg, location, LEVELS[WARN])

func debug(msg: String, location: String) -> void:
	if Constants.DEBUG:
		_emit_log(msg, location, LEVELS[DEBUG])

func error(msg: String, location: String) -> void:
	_emit_log(msg, location, LEVELS[ERROR])

func _emit_log(msg: String, location: String, level: Dictionary) -> bool:
	var traceStatement: String = "(%s): " % _get_location(location)
	var log: String = "%s %s%s" %[level[PREFIX], traceStatement, msg]
	var formatedLog: String = "[color=%s]%s[/color]" %[level[COLOR], log]
	print_rich(formatedLog)
	return true

func _get_location(location: String) -> String:
	return get_classname_from_path(location)

func get_classname_from_path(path: String) -> String:
	var searchResult = regex.search(path)
	if (searchResult):
		var classname: String = searchResult.get_string("className")
		return classname if classname else (path if (path != "") else "")
	return (path if (path != "") else "")
