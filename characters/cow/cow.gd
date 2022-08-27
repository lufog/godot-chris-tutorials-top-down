extends CharacterBody2D


enum CowState { IDLE, WALK }

@export var move_speed := 20.0
@export var idle_time := 5.0
@export var walk_time := 2.0

var move_direction := Vector2.ZERO
var current_state: CowState = CowState.IDLE

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var change_state_timer: Timer = $ChangeStateTimer


func _ready() -> void:
	select_new_direction()
	change_state_timer.start(idle_time)


func _physics_process(_delta: float) -> void:
	if current_state == CowState.WALK:
		velocity = move_direction * move_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func select_new_direction() -> void:
	move_direction = Vector2(
		randi_range(-1, 1),
		randi_range(-1, 1)
	).normalized()
	scale.x = 1 if move_direction.x > 0 else -1

func pick_new_state() -> void:
	if current_state == CowState.IDLE:
		current_state = CowState.WALK
		state_machine.travel("WalkRight")
		select_new_direction()
		change_state_timer.start(walk_time)
	elif current_state == CowState.WALK:
		current_state = CowState.IDLE
		state_machine.travel("IdleRight")
		change_state_timer.start(idle_time)


func _on_change_state_timer_timeout() -> void:
	pick_new_state()
