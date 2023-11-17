extends CanvasLayer

@onready var dash_charge_label = $Label
@onready var sweep = $TextureRect/TextureProgressBar
@onready var timer = $Timer

var cooldown: float = 1

var charging: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player:
		cooldown = player.dash_charge_cooldown
		player.dash_used.connect(start_charging)
		player.dash_at_max_charges.connect(stop_charging)
		player.dash_set_charges.connect(set_charge_label.bind())
	
	timer.wait_time = cooldown
	sweep.value = 0


func _process(delta):
	sweep.value = int((timer.time_left / cooldown) * 100)


func start_charging():
	timer.start()


func stop_charging():
	sweep.value = 0
	timer.stop()


func set_charge_label(charges: int):
	print_debug("given charges = %d" % charges)
	dash_charge_label.text = str(charges)
