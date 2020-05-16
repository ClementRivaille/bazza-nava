extends Control
class_name UI

onready var press_start : DynamicText = $PressStart
onready var rules : DynamicText = $Rules
onready var rules_2 : DynamicText = $Rules2
onready var quit : DynamicText = $Quit
onready var restart : DynamicText = $Restart
onready var bouncing : DynamicText = $Bouncing
onready var rules_timer : Timer = $RulesTimer
onready var bouncing_timer : Timer = $BouncingTimer
onready var bounce_rule_timer : Timer = $BounceRuleTimer

var rules_shown := false

func _ready():
  rules_timer.connect("timeout", self, "_hide_rules")
  bouncing_timer.connect("timeout", self, "_hide_bouncing")
  bounce_rule_timer.connect("timeout", self, "_show_bounce_rule")

func remove_start():
  press_start.hide()
  
func show_rules():
  if !rules_shown:
    display_rules(false)
    bounce_rule_timer.start()
    rules_shown = true

func _show_bounce_rule():
  display_rules(true)
  
func display_rules(bounce: bool):
  var label := rules
  if bounce:
    label = rules_2
  label.display()
  
  rules_timer.start()
  
func _hide_rules():
  rules.hide()
  rules_2.hide()
  
func display_end():
  quit.fade_time = restart.fade_time
  quit.display()
  restart.display()

func hide_end():
  quit.hide()
  restart.hide()
  
func set_bouncing(value: bool):
  if value:
    bouncing.set_text("Bouncing sounds enabled")
  else:
    bouncing.set_text("Bouncing sounds disabled")  
  bouncing.display()
  
  bouncing_timer.stop()
  bouncing_timer.start()
  
func _hide_bouncing():
  bouncing.hide()