extends Resource
class_name Section

var chord: int
var mode: int

func _init(json_data: Dictionary):
  chord = json_data["chord"]
  if json_data.has("mode"):
    mode = MusicTheory.SCALES[json_data["mode"]]
