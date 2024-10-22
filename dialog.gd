extends Control

@onready var my_popup_dialog = $Popup  # Reference to the PopupDialog node
@onready var open_button = $Open        # Reference to the Open button
@onready var close_button = my_popup_dialog.get_node("Panel/VBoxContainer/Close")  # Reference to the Close button

func _ready():
	# Connect signals
	open_button.pressed.connect(_on_open_popup_button_pressed)  # Connect Open button signal
	close_button.pressed.connect(_on_close_popup_button_pressed)  # Connect Close button signal

# Function to handle input events
func _input(event):
	# Check if the event is a key press and if the Spacebar is pressed
	if event.is_action_pressed("ui_accept"):  # "ui_accept" is the default action for the Spacebar
		_on_open_popup_button_pressed()  # Call the function to open the popup

# Function to show the popup
func _on_open_popup_button_pressed():
	my_popup_dialog.popup_centered()

# Function to close the popup
func _on_close_popup_button_pressed():
	my_popup_dialog.hide()
