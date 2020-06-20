tool
extends CenterContainer
class_name DynamicText

export(bool) var display_on_start := true
export(String) var text := "Text"
export(float) var fade_time := 0.5
export(bool) var blinking := false

var BLINK_LENGTH := 1.6

onready var label: Label = $Label
onready var tween: Tween = $Tween

var blink_direction_out := true

func _ready():
  label.text = text
  
  if (!display_on_start):
    modulate = Color(1,1,1,0)

  elif blinking:
    blink_out()

# Fade out for a blink
func blink_out():
  tween.interpolate_property(label, "modulate", Color(1,1,1,1), Color(1,1,1,0),
    BLINK_LENGTH / 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.disconnect("tween_all_completed", self, "blink_out")
  tween.connect("tween_all_completed", self, "blink_in")
  tween.start()
  blink_direction_out = true

# Fade in for a blink
func blink_in():
  tween.interpolate_property(label, "modulate", Color(1,1,1,0), Color(1,1,1,1),
    BLINK_LENGTH / 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
  tween.disconnect("tween_all_completed", self, "blink_in")
  tween.connect("tween_all_completed", self, "blink_out")
  tween.start()
  blink_direction_out = false

# Display text with fade in
func display():
  # Do nothing if already displayed
  if modulate.a > 0:
    return
  
  # Tween self modulate
  tween.remove_all()
  tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1),
    fade_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
  # If blinking, start blink once fading is over
  if blinking:
    tween.connect("tween_all_completed", self, "blink_out")
  tween.start()
  
# Hide with fade out
func hide():
  # Do nothing if already hidden
  if modulate.a == 0:
    return

  # stop eventual blinking
  if blinking:
    if blink_direction_out:
      tween.disconnect("tween_all_completed", self, "blink_in")
    else:
      tween.disconnect("tween_all_completed", self, "blink_out")
  
  # fade
  tween.remove_all()
  tween.interpolate_property(self, "modulate", modulate, Color(1,1,1,0),
    fade_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
  tween.start()
  
# Edit text
func set_text(text: String):
  label.text = text
