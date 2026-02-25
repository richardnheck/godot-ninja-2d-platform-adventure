#-----------------------------------------------------------
# This Autoload is used to remember the state of the main
# screen in order to primarily resource the Settings screen
# when the MainScreen is reloaded after navigating away
# from the Settings screen e.g. Functionaliy in Extras tab
#-----------------------------------------------------------
extends Node

# Indicates whether the settings are open
var settings_open:bool = false

# Indicates the current tab open in the settings 
var settings_current_tab_index:int = 0

