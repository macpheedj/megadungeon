extends Area2D
class_name Character


signal turn_ended


enum State {
    Adventuring,
    StandingBy,
    TakingTurn,
}


@export var state: State
@export var movespeed := 5
