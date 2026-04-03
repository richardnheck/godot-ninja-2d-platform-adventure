extends Node

# The number of deaths for the current level
var deaths = 0

func increment_deaths() -> void:
	deaths = deaths + 1
	print("deaths for level = " + str(deaths))

func reset_deaths() -> void:
	print("reset deaths for level")
	deaths = 0
