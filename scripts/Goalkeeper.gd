class_name Goalkeeper
extends FieldPlayer

# Goalkeeper can save the ball if their "save meter" is still full
# Ever save depletes the save meter, and once empty, the next shot is guaranteed to go in

@onready var save_meter = $SaveMeter as ProgressBar

func _ready():
  save_meter.value = 100
