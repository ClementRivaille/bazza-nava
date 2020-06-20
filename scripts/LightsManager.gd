extends Spatial
class_name LightsManager

export(float) var default_energy := 0.9

func _ready():
  for c in get_children():
    var child := c as Node
    var tween = Tween.new()
    child.add_child(tween)
    
func fade_off(time: float):
  for c in get_children():
    var light := c as Light
    var tween: Tween = light.get_child(0)
    tween.stop_all()
    tween.interpolate_property(light, "light_energy", light.light_energy, 0,
      time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
    tween.start()

func turn_on():
  for c in get_children():
    var light := c as Light
    var tween: Tween = light.get_child(0)
    tween.stop_all()
    tween.interpolate_property(light, "light_energy", 0, default_energy,
      0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
    tween.start()
