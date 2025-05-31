extends Node

# Gestionnaire de sons simple et pratique
# Utilisation : SoundManager.play("nom_du_fichier")
# Exemple : SoundManager.play("explosion.wav")

# Dictionnaires pour stocker les références
var sounds = {}
var music_player: AudioStreamPlayer
var current_music = ""

# Dossiers où chercher les fichiers audio
const SOUNDS_PATH = "res://assets/sound/"
const MUSIC_PATH = "res://assets/music/"

func _ready():
	# Créer le lecteur de musique principal
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Charger automatiquement tous les sons au démarrage
	load_all_sounds()

# Charge tous les fichiers audio des dossiers
func load_all_sounds():
	_load_sounds_from_directory(SOUNDS_PATH)
	_load_sounds_from_directory(MUSIC_PATH)

func _load_sounds_from_directory(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".wav") or file_name.ends_with(".ogg") or file_name.ends_with(".mp3"):
				var full_path = path + file_name
				var sound_name = file_name.get_basename() # nom sans extension
				sounds[sound_name] = load(full_path)
				print("Son chargé : ", sound_name)
			file_name = dir.get_next()

# Redémarrer la musique actuelle depuis le début
func restart_music(fadein_duration: float = 0.0):
	if current_music == "":
		print("Aucune musique à redémarrer")
		return
	
	play_music(current_music, music_player.volume_db, true, fadein_duration, true)

# ========== NOUVELLES FONCTIONS ==========

# Jouer un son au hasard parmi une liste
func play_random(sound_names: Array, volume: float = 0.0, pitch: float = 1.0):
	if sound_names.is_empty():
		print("Erreur : Liste de sons vide !")
		return
	
	var random_sound = sound_names[randi() % sound_names.size()]
	play(random_sound, volume, pitch)

# Jouer un son avec pitch aléatoire dans une fourchette
func play_with_random_pitch(sound_name: String, pitch_min: float = 0.8, pitch_max: float = 1.2, volume: float = 0.0):
	var random_pitch = randf_range(pitch_min, pitch_max)
	play(sound_name, volume, random_pitch)

# Jouer un son au hasard parmi tous les sons chargés d'un type
func play_random_from_category(category_prefix: String = "", volume: float = 0.0, pitch: float = 1.0):
	var matching_sounds = []
	
	for sound_name in sounds.keys():
		if category_prefix == "" or sound_name.begins_with(category_prefix):
			matching_sounds.append(sound_name)
	
	if matching_sounds.is_empty():
		print("Erreur : Aucun son trouvé pour la catégorie '", category_prefix, "' !")
		return
	
	var random_sound = matching_sounds[randi() % matching_sounds.size()]
	play(random_sound, volume, pitch)

# ========== FONCTIONS PRINCIPALES ==========

# Jouer un son simple (une fois)
func play(sound_name: String, volume: float = 0.0, pitch: float = 1.0):
	if not sounds.has(sound_name):
		print("Erreur : Son '", sound_name, "' introuvable !")
		return
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = sounds[sound_name]
	player.volume_db = volume
	player.pitch_scale = pitch
	player.play()
	
	# Se détruit automatiquement à la fin
	player.finished.connect(_on_sound_finished.bind(player))

# Jouer un son en boucle
func play_loop(sound_name: String, volume: float = 0.0, pitch: float = 1.0) -> AudioStreamPlayer:
	if not sounds.has(sound_name):
		print("Erreur : Son '", sound_name, "' introuvable !")
		return null
	
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = sounds[sound_name]
	player.volume_db = volume
	player.pitch_scale = pitch
	
	# Activer la boucle selon le type de stream
	if player.stream is AudioStreamOggVorbis:
		player.stream.loop = true
	elif player.stream is AudioStreamWAV:
		player.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	
	player.play()
	return player # Retourne le player pour pouvoir l'arrêter plus tard

# Jouer de la musique (remplace la musique actuelle)
func play_music(music_name: String, volume: float = 0.0, loop: bool = true, fadein_duration: float = 0.0, force_restart: bool = false):
	if not sounds.has(music_name):
		print("Erreur : Musique '", music_name, "' introuvable !")
		return
	
	# Si c'est la même musique et qu'on ne force pas le redémarrage, ne rien faire
	if current_music == music_name and music_player.playing and not force_restart:
		print("La musique '", music_name, "' joue déjà")
		return
	
	# Arrêter la musique actuelle avec fadeout si elle joue
	if music_player.playing:
		stop_music_fadeout(0.5)
		await get_tree().create_timer(0.5).timeout
	
	music_player.stream = sounds[music_name]
	current_music = music_name
	
	# Configurer la boucle
	if loop:
		if music_player.stream is AudioStreamOggVorbis:
			music_player.stream.loop = true
		elif music_player.stream is AudioStreamWAV:
			music_player.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	
	# Gérer le fadein
	if fadein_duration > 0.0:
		music_player.volume_db = -80  # Commencer silencieux
		music_player.play()
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", volume, fadein_duration)
	else:
		music_player.volume_db = volume
		music_player.play()

# Arrêter un son avec fadeout
func stop_sound_fadeout(player: AudioStreamPlayer, duration: float = 1.0):
	if not player or not is_instance_valid(player):
		return
	
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, duration)
	tween.tween_callback(player.queue_free)

# Arrêter la musique avec fadeout
func stop_music_fadeout(duration: float = 1.0):
	if not music_player.playing:
		return
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80, duration)
	tween.tween_callback(music_player.stop)
	tween.tween_callback(func(): music_player.volume_db = 0)

# Arrêter la musique immédiatement
func stop_music():
	music_player.stop()
	current_music = ""

# Mettre la musique en pause/reprendre
func pause_music():
	music_player.stream_paused = not music_player.stream_paused

# ========== FONCTIONS UTILITAIRES ==========

# Changer le volume général de la musique
func set_music_volume(volume: float):
	music_player.volume_db = volume

# Vérifier si une musique joue
func is_music_playing() -> bool:
	return music_player.playing

# Obtenir le nom de la musique actuelle
func get_current_music() -> String:
	return current_music

# Lister tous les sons disponibles
func list_available_sounds():
	print("Sons disponibles :")
	for sound_name in sounds.keys():
		print("- ", sound_name)

# Callback quand un son se termine
func _on_sound_finished(player: AudioStreamPlayer):
	player.queue_free()
