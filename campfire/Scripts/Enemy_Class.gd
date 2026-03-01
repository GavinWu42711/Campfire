extends CharacterBody2D

class_name Enemy

#Variables to be set 
#Movement 
@export var move_speed:float = 300.0
@export var rotation_speed:float = 1 #Degrees/s

#Health and attacking
@export var enemy_attack_damage:int = 10
@export var max_health:int = 100
@export var enemy_hitbox:CollisionShape2D
@export var enemy_attack_hitbox:Area2D
@export var i_frame_length:float = 1 # in seconds
@export var follow_distance = 0 #How closely to try and follow the player

#Sprites and animations
@export var animated_sprite:AnimatedSprite2D

#Variables NOT to be set
#Health and attacking
var current_health:int
var can_take_damage:bool = true
var alive:bool = true

#Sprites and animations
enum ACTION {ATTACK,DEATH,HURT,IDLE,WALK}
var queued_enemy_animation = [false, false, false, false, false] #Each boolean corresponds to an action in the enum
var current_enemy_animation = [false,false,false,false,false]

#Signal for the enemy to take damage; helps with decoupling
signal take_damage_signal(damage:int)

#Run once when the enemy is first instantiated
func _ready() -> void:
	current_health = max_health
	take_damage_signal.connect(take_damage)

#Run every second
func _physics_process(delta: float) -> void:
	chase_player(delta)
	check_attack_hitbox()
	move_and_slide()
	
	print("Enemy health: " + str(current_health))

#Try to queue an animation
func queue_animation(animation_action:int) -> void:
	queued_enemy_animation[animation_action] = true

#Reset booleans for current_enemy_animation
func reset_current_animations() -> void:
	for i in range(len(current_enemy_animation)):
		current_enemy_animation[i] = true

func current_animation_logic() -> void:
	if not current_enemy_animation[ACTION.DEATH]:
		if queued_enemy_animation[ACTION.DEATH]:
			reset_current_animations()
			current_enemy_animation[ACTION.DEATH] = true
			queued_enemy_animation[ACTION.DEATH] = false
		elif not current_enemy_animation[ACTION.HURT]:
			if queued_enemy_animation[ACTION.HURT]:
				reset_current_animations()
				current_enemy_animation[ACTION.HURT] = true
				queued_enemy_animation[ACTION.HURT] = false
			elif not current_enemy_animation[ACTION.ATTACK]:
				if queued_enemy_animation[ACTION.ATTACK]:
					reset_current_animations()
					current_enemy_animation[ACTION.ATTACK] = true
					queued_enemy_animation[ACTION.ATTACK] = false
				elif not current_enemy_animation[ACTION.WALK]:
					if queued_enemy_animation[ACTION.WALK]:
						reset_current_animations()
						current_enemy_animation[ACTION.WALK] = true
						queued_enemy_animation[ACTION.WALK] = false
					elif not current_enemy_animation[ACTION.IDLE]:
						if queued_enemy_animation[ACTION.IDLE]:
							reset_current_animations()
							current_enemy_animation[ACTION.IDLE] = true
							queued_enemy_animation[ACTION.IDLE] = false

#Changes the animation of the enemy depending on the action they're supposed to have
func animation_handler() -> void:
	current_animation_logic()
	
	
#Makes the enemy take damage
func take_damage(damage:int):
	print("taking damage")
	if can_take_damage and alive:
		#Start i-frame
		can_take_damage = false
		
		#Start i-frame cooldown
		take_damage_cooldown(i_frame_length)
		
		#Apply damage
		current_health -= damage
		
		if current_health <= 0:
			current_health = 0
			alive = false
			die()
		
#Starts a timer to allow the enemy to take damage again
func take_damage_cooldown(cooldown_length) -> void:
	await get_tree().create_timer(cooldown_length).timeout
	can_take_damage = true

#When the enemy dies
func die() -> void:
	pass
	
#Checks if any player hitboxes are in range
func check_attack_hitbox() -> void:
	for body in enemy_attack_hitbox.get_overlapping_bodies():
		if body is Player:
			attack(enemy_attack_damage,body.take_damage_signal)

#Deals damage to the player
func attack(attack_damage:int,hitbox_signal:Signal) -> void:
	hitbox_signal.emit(attack_damage)
	
#Chases the player if possible
func chase_player(delta:float) -> void:
	var player_pos:Vector2 = Global.player_pos
	var enemy_pos:Vector2 = self.global_position
		
	if player_pos != null: #Make sure the player pos has a value
		#Apply rotation first
		if enemy_pos.distance_to(player_pos) > 0 and rotation_speed != 0:
			#Determine if the enemy should turn left or right based on the player's heading r
			#relative to the enemy and the enemy's current rotation
			
			#Calculating player heading
			var dX:float = player_pos.x - enemy_pos.x #Adjacent
			var dY:float = -player_pos.y - (-enemy_pos.y) #Opposite
			
			var alpha:float
			var player_heading:float
			
			if dX > 0 and dY >= 0: #Quadrant 1
				alpha = rad_to_deg(atan2(dY,dX))
				player_heading = 90 - alpha 
			elif dX < 0 and dY >= 0: #Quadrant 2
				alpha = 180 - rad_to_deg(atan2(dY,dX))
				player_heading = 270 + alpha
			elif dX < 0 and dY <= 0: #Quadrant 3
				alpha = 180 - abs(rad_to_deg(atan2(dY,dX)))
				player_heading = 270 - alpha
			elif dX > 0 and dY <= 0: #Quadrant 4
				alpha = abs(rad_to_deg(atan2(dY,dX)))
				player_heading = 90 + alpha
			elif dX == 0 and dY > 0: #Directly above
				player_heading = 0
			elif dX == 0 and dY < 0: #Directly below
				player_heading = 180
			
			#If the difference is above 360
			player_heading = player_heading - (int(player_heading / 360) * 360)
			
			var enemy_heading = self.rotation_degrees - (int(self.rotation_degrees / 360) * 360)
			if enemy_heading < 0:
				enemy_heading += 360
			
			#Difference in heading
			var dOmega:float = player_heading - enemy_heading
			if dOmega < 0:
				dOmega += 360
					
			#Check difference in heading
			if dOmega <= 180: #Turn right
				self.rotation += deg_to_rad(rotation_speed) * delta
			else: #Turn left
				self.rotation -= deg_to_rad(rotation_speed) * delta
		
		if enemy_pos.distance_to(player_pos) > follow_distance and move_speed != 0:
			#Initial move forward vector
			var forward_vector:Vector2 = Vector2.UP
			
			#Apply speed
			forward_vector = forward_vector * move_speed * delta
			
			#Apply rotation
			forward_vector = forward_vector.rotated(self.rotation)
			
			#Apply vector
			self.translate(forward_vector)
		
	
