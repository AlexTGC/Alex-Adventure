class_name ScoreIndicator
extends Label

@export var duration_score_update : float
@export var points_per_life : int

var displayed_score := 0
var prior_score := 0
var real_score := 0
var time_start_update := Time.get_ticks_msec()

func _init() -> void:
	DamageManager.player_revive.connect(on_player_revive.bind())

func _ready() -> void:
	displayed_score = 0
	refresh()

# 5 => 5 + 4 + 3 + 2 + 1 = 15
# 4 => 4 + 3 + 2 + 1 = 10
func add_combo(points: int) -> void:
	add_points(int((points * (points + 1)) / 2.0))

func start_update() -> void:
	prior_score = displayed_score
	time_start_update = Time.get_ticks_msec()
	refresh()

func on_player_revive() -> void:
	add_points(-points_per_life)

func add_points(points: int) -> void:
	real_score = max(0, real_score + points)
	start_update()

func _process(_delta: float) -> void:
	if real_score != displayed_score:
		var progress := (Time.get_ticks_msec() - time_start_update) / duration_score_update
		if progress < 1:
			displayed_score = lerp(prior_score, real_score, progress)
		else:
			displayed_score = real_score
		refresh()

func refresh() -> void:
	text = str(displayed_score)
