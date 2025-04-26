extends Node

const MAX_RANGE = 130 #define o raio maximo para detectar inimigos proximos
const MAX_UPGRADES = 7.0

@export var pickaxe_ability: PackedScene

var damage = 5
var base_wait_time


func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

func on_timer_timeout(): #exetado quando o temporizador dispara
	var player = get_tree().get_first_node_in_group("player") as Node2D #encontra o jogador e inimigos proximos
	if player == null: #ordena os inimigos pela distancia em relação ao jogador
		return #instancia e posiciona a hab pick perto do inimigo mais prox
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)

	if enemies.size() == 0:
		return

	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance< b_distance
		)
		
	var pickaxe_instance = pickaxe_ability.instantiate() as PickaxeAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(pickaxe_instance)
	player.get_parent().add_child(pickaxe_instance)
	pickaxe_instance.hitbox_component.damage = damage
	
	pickaxe_instance.global_position = enemies[0].global_position
	pickaxe_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - pickaxe_instance.global_position
	pickaxe_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary): #ajusta o tempo de espera do temporizador baseado no efeito de uma melhoria pick_rate"
	if upgrade.id != "pick_rate":
		return
		
	var percent_reduction = current_upgrades["pick_rate"]["quantity"] / MAX_UPGRADES
	var new_wait_time = max(base_wait_time - percent_reduction, 0.1)
	
	$Timer.wait_time = new_wait_time
	$Timer.start()
	print(percent_reduction)
