extends Spatial
class_name Main

onready var multisampler: Multisampler = $Multisampler
onready var sampler: Multisampler = $Sampler
onready var player: Player = $Player
onready var metronome: MetronomePlayer = $MetronomePlayer

var notes := ["C", "D", "E", "F", "G", "A", "B", "B#"]
var idx :=0

var sheet: MusicSheet
var sheet_path := "res://assets/sheet.json"

func _ready():
  var music_theory: MusicTheory = get_node("/root/MusicTheory")
  player.setHarmony("A", music_theory.Scale.LYDIAN)
  # metronome.play()
  metronome.connect("beat", self, "on_beat")
  metronome.connect("measure", sampler, "play_note", ["Ab", 4])
  
  _read_sheet(sheet_path)
  print(sheet.measures)

func _input(event: InputEvent):
  if event.is_pressed():
    # multisampler.play_note(notes[idx], 4)
    # idx = (idx + 1) % notes.size()
    player.play_random_note()

func on_beat(n: int):
  player.play_random_note()

func _read_sheet(source_file: String):
    var file := File.new()
    var err = file.open(source_file, File.READ)
    if err != OK:
        return err

    var text = file.get_as_text()
    var dict := JSON.parse(text)

    file.close()
    if (dict.error):
      print(str(dict.error_line) + ': ' + dict.error_string)
      get_tree().quit()
      
    sheet = MusicSheet.new(dict.result)
