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
	animation_handler()
	
	print("Enemy health: " + str(current_health))
	
#Makes the enemy take damage
func take_damage(damage:int):
	#print("taking damage")
	if can_take_damage and alive:
		#Start i-frame
		can_take_damage = false
		
		#Start i-frame cooldown
		take_damage_cooldown(i_frame_length)
		
		#Apply damage
		current_health -= damage
		queue_animation(ACTION.HURT)
		
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
	queue_animation(ACTION.DEATH)
	
#Checks if any player hitboxes are in range
func check_attack_hitbox() -> void:
	for body in enemy_attack_hitbox.get_overlapping_bodies():
		if body is Player:
			attack(enemy_attack_damage,body.take_damage_signal)

#Deals damage to the player
func attack(attack_damage:int,hitbox_signal:Signal) -> void:
	hitbox_signal.emit(attack_damage)
	queue_animation(ACTION.ATTACK)
	
#Chases the player if possible
func chase_player(delta:float) -> void:
	var player_pos:Vector2 = Global.player_pos
	var enemy_pos:Vector2 = self.global_position
	var dOmega:float
		
	if player_pos != null: #Make sure the player pos has a value
		#Apply rotation first
		if enemy_pos.distance_to(player_pos) > 0:
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
			dOmega = player_heading - enemy_heading
			if dOmega < 0:
				dOmega += 360
					
			if rotation_speed != 0:
				#Check difference in heading
				if dOmega <= 180: #Turn right
					self.rotation += deg_to_rad(rotation_speed) * delta
				else: #Turn left
					self.rotation -= deg_to_rad(rotation_speed) * delta
				dOmega = self.rotation_degrees
			else:
				dOmega = player_heading
		
		if enemy_pos.distance_to(player_pos) > follow_distance and enemy_pos.distance_to(player_pos) > 0:
			#Initial move forward vector
			var forward_vector:Vector2 = Vector2.UP
			
			#Apply speed
			forward_vector = forward_vector * move_speed * delta
			
			#Apply rotation
			forward_vector = forward_vector.rotated(deg_to_rad(dOmega))
			
			#Apply vector
			self.translate(forward_vector)
					
		queue_animation(ACTION.WALK)
		
	else:
		queue_animation(ACTION.IDLE)
#Try to queue an animation
func queue_animation(animation_action:int) -> void:
	queued_enemy_animation[animation_action] = true

#Reset booleans for current_enemy_animation
func reset_current_animations() -> void:
	for i in range(len(current_enemy_animation)):
		current_enemy_animation[i] = false

#Reset booleans for queued_enemy_animation
func reset_queued_animations() -> void:		
	for i in range(len(queued_enemy_animation)):
		queued_enemy_animation[i] = false
		
func stop_animation() -> void:
	if animated_sprite.is_playing():
		animated_sprite.stop()
	
#Changes the animation of the enemy depending on the action they're queued to have and currently are doing
func animation_handler() -> void:
	print(queued_enemy_animation)
	if not current_enemy_animation[ACTION.DEATH]:
		
		if queued_enemy_animation[ACTION.DEATH]:
			stop_animation()	
			reset_current_animations()
			current_enemy_animation[ACTION.DEATH] = true
			queued_enemy_animation[ACTION.DEATH] = false
			death_animation()
			
		elif not current_enemy_animation[ACTION.HURT]:
			if queued_enemy_animation[ACTION.HURT]:
				stop_animation()
				reset_current_animations()
				current_enemy_animation[ACTION.HURT] = true
				queued_enemy_animation[ACTION.HURT] = false
				hurt_animation()
				
			elif not current_enemy_animation[ACTION.ATTACK]:
				if queued_enemy_animation[ACTION.ATTACK]:
					stop_animation()
					reset_current_animations()
					current_enemy_animation[ACTION.ATTACK] = true
					queued_enemy_animation[ACTION.ATTACK] = false
					attack_animation()
					
				elif not current_enemy_animation[ACTION.WALK]:
					if queued_enemy_animation[ACTION.WALK]:
						stop_animation()
						reset_current_animations()
						current_enemy_animation[ACTION.WALK] = true
						queued_enemy_animation[ACTION.WALK] = false
						walk_animation()
						
					elif not current_enemy_animation[ACTION.IDLE]:
						if queued_enemy_animation[ACTION.IDLE]:
							stop_animation()
							reset_current_animations()
							current_enemy_animation[ACTION.IDLE] = true
							queued_enemy_animation[ACTION.IDLE] = false
							idle_animation()
							
	reset_queued_animations()

#Should only run once
func attack_animation() -> void:
	animated_sprite.play("attack")
	await animated_sprite.animation_finished
	current_enemy_animation[ACTION.ATTACK] = false

#Should only run once	
func death_animation() -> void:
	animated_sprite.play("death") #No animation should play after this

#Should not infinitely loop
func hurt_animation() -> void:
	animated_sprite.play("hurt")
	await animated_sprite.animation_finished
	current_enemy_animation[ACTION.HURT] = false

#Should loop
func idle_animation() -> void:
	animated_sprite.play("idle")

#Should loop
func walk_animation() -> void:
	animated_sprite.play("walk")
