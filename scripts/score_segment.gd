extends Resource
class_name ScoreSegment

var measures: int
var beats: int
var section: int

func _init(json_data: Dictionary):
  measures = json_data["measures"] if json_data.has("measures") else 0
  beats = json_data["beats"] if json_data.has("beats") else 0
  section = json_data["section"] if json_data.has("section") else 0
