extends CenterContainer
class_name Exit

signal exit

onready var circle: TextureRect = $Circle
onready var timer: Timer = $Timer
onready var tween: Tween = $Tween

export(float) var duration := 1.0
export(float) var cancel_duration := 0.2

func _ready():
  timer.connect("timeout", self, "show_circle")
  tween.connect("tween_started", self, "_display_circle")

# Wait a few time before starting animation
func start_timer():
  if timer.is_stopped():
    timer.start()

# Start animation from the beginning
func show_circle():
  circle.visible = true
  circle.rect_scale = Vector2(0,0)
  grow_circle(0.0)

# Remove transparency on circle (to avoid frame where it's full scale)
func _display_circle(_object, _key):
  circle.self_modulate = Color(1,1,1,1)

# Grow the circle from completion (between 0 & 1)
func grow_circle(completion: float):
  tween.interpolate_property(circle, "rect_scale", Vector2(completion,completion), Vector2(1,1),
    duration * (1 - completion), Tween.TRANS_SINE, Tween.EASE_IN)
  tween.connect("tween_all_completed", self, "emit_exit")
  tween.start()
  
# Emit signal once animation is completed
func emit_exit():
  emit_signal("exit")

# Start or continue exit animation
func activate():
  # Animation not started, launch timer
  if !circle.visible:
    start_timer()
  else:
    # Cancel shrinking animation, proceed growing one
    tween.remove_all()
    tween.disconnect("tween_all_completed", self, "hide_circle")
    grow_circle(circle.rect_scale.x)

# Cancel exit animation, shrink circle
func cancel():
  # Stop timer
  if !timer.is_stopped():
    timer.stop()
  
  # Or shrink circle
  if circle.visible:
    tween.remove_all()
    tween.interpolate_property(circle, "rect_scale", circle.rect_scale, Vector2(0,0),
      cancel_duration, Tween.TRANS_SINE, Tween.EASE_IN)
    # Disconnect and reconnect tween
    tween.disconnect("tween_all_completed", self, "emit_exit")
    tween.connect("tween_all_completed", self, "hide_circle")
    tween.start()
    
# Hide circle once its shrinking animation is complete
func hide_circle():
  circle.visible = false
  circle.self_modulate = Color(1,1,1,0)
  # Tween must be disconnected for next growing
  tween.disconnect("tween_all_completed", self, "hide_circle")