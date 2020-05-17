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
onready var esc_display_timer : Timer = $EscDisplayTimer
onready var exit: Exit = $Exit

var rules_shown := false
var end_screen := false
onready var quit_fade_time = quit.fade_time

func _ready():
  rules_timer.connect("timeout", self, "_hide_rules")
  bouncing_timer.connect("timeout", self, "_hide_bouncing")
  bounce_rule_timer.connect("timeout", self, "_show_bounce_rule")
  esc_display_timer.connect("timeout", self, "hide_quit")
  exit.connect("exit", self, "quit")

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
  end_screen = true

func hide_end():
  quit.hide()
  restart.hide()
  end_screen = false
  
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
  
func _input(event):
  if event.is_action_pressed("ui_cancel"):
    # Show how to exit for a short amount of seconds
    if !end_screen:
      quit.fade_time = quit_fade_time
      quit.display()
      if !esc_display_timer.is_stopped():
        esc_display_timer.stop()
      esc_display_timer.start()
    # Start (or proceed) exit animation
    exit.activate()
  if event.is_action_released("ui_cancel"):
    # Cancel exit animation
    exit.cancel()
    
func hide_quit():
  quit.hide()

func quit():
  get_tree().call_deferred("quit")