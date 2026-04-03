#-------------------------
# Environment
#-------------------------
extends Node

var talo_access_key = null

func _ready():
	var config = ConfigFile.new()
	var err = config.load("res://env.cfg")	
	if err == OK:
		talo_access_key = config.get_value("keys", "talo_access_key", "")
