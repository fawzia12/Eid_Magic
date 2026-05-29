import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const String _settingsBox = 'settingsBox';
  static const String _soundEffectsKey = 'soundEffectsEnabled';

  bool _soundEffectsEnabled = true;

  final AudioPlayer _musicPlayer = AudioPlayer();

  bool get soundEffectsEnabled => _soundEffectsEnabled;

  AudioProvider() {
    _init();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _init() async {
    final box = await Hive.openBox(_settingsBox);
    _soundEffectsEnabled = box.get(_soundEffectsKey, defaultValue: true);
    notifyListeners();

    await _setupAudio();
  }

  Future<void> _setupAudio() async {
  
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void startHomeMusic() {
    if (_soundEffectsEnabled) {
      _playMusic();
    }
  }

  void _playMusic() async {
    if (_musicPlayer.state == PlayerState.playing) {
      return; // Do not restart if it is already playing
    }

    if (_musicPlayer.state == PlayerState.paused) {
      await _musicPlayer.resume();
      return;
    }

    try {
      final byteData = await rootBundle.load(
        'assets/audio/tabsirah_nasheed.mp3',
      );
      final buffer = byteData.buffer;
      final bytes = buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      await _musicPlayer.play(BytesSource(bytes));
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _stopMusic() {
    _musicPlayer.pause(); // Pause instead of stop to resume quickly
  }

  // The user requested that the "Sound Effects" toggle controls the music.
  Future<void> toggleSoundEffects() async {
    _soundEffectsEnabled = !_soundEffectsEnabled;
    notifyListeners();

    final box = await Hive.openBox(_settingsBox);
    await box.put(_soundEffectsKey, _soundEffectsEnabled);

    if (_soundEffectsEnabled) {
      _playMusic();
    } else {
      _stopMusic();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _musicPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_soundEffectsEnabled) {
        _playMusic();
      }
    } else {
      if (_musicPlayer.state == PlayerState.playing) {
        _musicPlayer.pause();
      }
    }
  }
}
