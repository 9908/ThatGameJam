@tool
extends Node
var performance_display: PerformancesDisplay
var phantom_camera_host: PhantomCameraHost
var current_camera: PhantomCamera2D

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	performance_display = PerformancesDisplay.new()
	add_child(performance_display)
	
	# Configurer le listener avec Phantom Camera
	setup_phantom_camera_listener()

func _exit_tree() -> void:
	remove_child(performance_display)
	performance_display.free()

func _process(delta):
	FmodServer.update()
	
	# Mettre à jour le listener avec la position de Phantom Camera
	update_listener_with_phantom_camera()
	
func _notification(what):
	FmodServer.notification(what)

func setup_phantom_camera_listener():
	await get_tree().create_timer(0.1).timeout
	
	# Configurer le listener de base
	FmodServer.set_listener_number(1)
	
	# Chercher le PhantomCameraHost
	find_phantom_camera_host()
	
	print("✓ Listener FMOD configuré avec Phantom Camera")

func find_phantom_camera_host():
	# Méthode 1: Chercher par groupe
	var hosts = get_tree().get_nodes_in_group("phantom_camera_host")
	if hosts.size() > 0:
		phantom_camera_host = hosts[0]
		print("✓ PhantomCameraHost trouvé par groupe")
		return
	
	# Méthode 2: Chercher dans toute la scène
	phantom_camera_host = find_phantom_host_recursive(get_tree().root)
	if phantom_camera_host:
		print("✓ PhantomCameraHost trouvé automatiquement")
	else:
		print("⚠️ PhantomCameraHost non trouvé")

func find_phantom_host_recursive(node: Node):
	# Chercher par nom de classe ou nom de node
	if node.get_class() == "PhantomCameraHost" or node.name.contains("PhantomCameraHost"):
		return node
	
	for child in node.get_children():
		var result = find_phantom_host_recursive(child)
		if result:
			return result
	
	return null

func update_listener_with_phantom_camera():
	if not phantom_camera_host:
		return
	
	# Obtenir la caméra active de Phantom Camera
	var active_camera = phantom_camera_host.get_active_pcam()
	if active_camera and active_camera != current_camera:
		current_camera = active_camera
		print("📷 Nouvelle caméra active: ", current_camera.name)
	
	# Mettre à jour la position du listener (version 2D simple)
	if current_camera and is_instance_valid(current_camera):
		update_listener_position_2d(current_camera.global_position)

func update_listener_position_2d(camera_position: Vector2):
	# Pour un jeu 2D, on peut juste notifier FMOD de la position sans vraiment l'utiliser
	# Car la plupart des sons 2D ne sont pas positionnels
	pass  # Pas besoin de vraie gestion 3D pour un jeu 2D pur

# === FONCTIONS POUR JOUER DES SONS 2D ===
# (vos fonctions précédentes restent identiques)

func play_sound(event_path: String):
	print("🔊 Lecture du son: ", event_path)
	var event_instance = FmodServer.create_event_instance(event_path)
	if event_instance:
		event_instance.start()
		event_instance.release()
		print("✓ Son joué avec succès")
		return true
	else:
		print("✗ Impossible de jouer le son: ", event_path)
		return false

# ... (reste des fonctions audio)
