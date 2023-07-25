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


@export var action_name: String = "Action"
@export var action_type: ActionType = ActionType.None
@export var min_range: int = 1
@export var max_range: int = 1
@export var damage_type: DamageType = DamageType.None
@export var damage_range: int = 6
@export var damage_bonus: int = 0
@export var attack_bonus: int = 0


func _init(
    _action_name: String = "Action",
    _action_type: ActionType = ActionType.None,
    _min_range: int = 1,
    _max_range: int = 1,
    _damage_type: DamageType = DamageType.None,
    _damage_range: int = 6,
    _damage_bonus: int = 0,
    _attack_bonus: int = 0,
):
    action_name = _action_name
    action_type = _action_type
    min_range = _min_range
    max_range = _max_range
    damage_type = _damage_type
    damage_range = _damage_range
    damage_bonus = _damage_bonus
    attack_bonus = _attack_bonus


func inject(entity: Entity):
    match action_type:
        ActionType.Movement:
            max_range = entity.movespeed
        
        # ActionType.Attack:
        #     var weapon = entity.weapon
        #     damage_type = weapon.damage_type
        #     damage_range = weapon.damage_range
        #     damage_bonus = entity[weapon.damage_stat]
        #     attack_bonus = entity[weapon.attack_stat]
