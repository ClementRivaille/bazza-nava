extends Resource
class_name MusicSheet

export(String) var root: String
export(int) var mode: int
var sections: Array
var score: Array

var next_segment: int

func _init(json_data: Dictionary):
  root = json_data["scale"]["note"]
  mode = MusicTheory.SCALES[json_data["scale"]["mode"]]
  sections = json_data["sections"]
  score = json_data["score"]
  next_segment = 0

func get_next_segment() -> ScoreSegment:
  return ScoreSegment.new(score[next_segment])

func get_section(idx: int) -> Section:
  return Section.new(sections[idx])

func change_segment():
  next_segment = (next_segment + 1) % score.size()

func is_last_segment() -> bool:
  return next_segment == score.size() - 1
  
func restart():
  next_segment = 0
