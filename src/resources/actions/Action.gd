extends Resource
class_name Action


enum ActionType {
    None = -1,
    Movement,
    Attack,
}
enum DamageType {
    None,
    Bonking,
    Poking,
    Chopping,
}


@export var action_type: ActionType = ActionType.None
@export var damage_type: DamageType = DamageType.None
@export var min_range: int = 1
@export var max_range: int = 1


func _init(
    _action_type: ActionType = ActionType.None,
    _damage_type: DamageType = DamageType.None,
    _min_range: int = 1,
    _max_range: int = 1,
):
    action_type = _action_type
    damage_type = _damage_type
    min_range = _min_range
    max_range = _max_range
