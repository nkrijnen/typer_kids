import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Manages sound effects for the app.
/// All sounds are CC0 synthesized originals (see tool/generate_sfx.dart).
class SoundManager {
  static final SoundManager _instance = SoundManager._();
  factory SoundManager() => _instance;
  SoundManager._();

  /// SharedPreferences key for persisting the sound on/off setting.
  static const String prefsKey = 'sound_enabled';

  /// Whether sound effects are enabled (toggled in Settings).
  bool enabled = true;

  /// Set to false if audio subsystem is unavailable (e.g. missing VC++ runtime).
  bool _audioAvailable = true;

  /// Players per sound, so the same effect can overlap with itself.
  static const int _voicesPerSound = 2;

  // Each sound keeps its own preloaded players. Re-setting the source on an
  // in-flight player leaks the native load continuation on macOS/iOS and wedges
  // that player permanently, so the source is set exactly once per player.
  final Map<String, Future<List<AudioPlayer>>> _voices = {};
  final Map<String, int> _nextVoice = {};

  Future<List<AudioPlayer>> _loadVoices(String asset) async {
    final players = <AudioPlayer>[];
    for (var i = 0; i < _voicesPerSound; i++) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setSource(AssetSource('sounds/$asset'));
      players.add(player);
    }
    return players;
  }

  Future<void> _play(String asset, {double volume = 0.5}) async {
    if (!enabled || !_audioAvailable) return;
    final List<AudioPlayer> players;
    try {
      players = await (_voices[asset] ??= _loadVoices(asset));
    } catch (e) {
      // One asset failing to load says nothing about the others, so drop it and
      // let the next play retry instead of silencing the whole app.
      _voices.remove(asset);
      debugPrint('Audio load failed ($asset): $e');
      return;
    }
    try {
      final index = (_nextVoice[asset] ?? 0) % players.length;
      _nextVoice[asset] = index + 1;
      final player = players[index];
      await player.setVolume(volume);
      await player.stop();
      await player.resume();
    } catch (e) {
      debugPrint('Audio error ($asset): $e');
      // Disable audio to prevent repeated failures / native crashes
      _audioAvailable = false;
    }
  }

  /// Correct keypress / word match
  Future<void> playCorrect() => _play('correct.wav', volume: 0.5);

  /// Wrong keypress / mismatch
  Future<void> playIncorrect() => _play('wrong.wav', volume: 0.4);

  /// Bubble pop / word destroyed
  Future<void> playPop() => _play('pop.wav', volume: 0.6);

  /// Missed word
  Future<void> playMiss() => _play('miss.wav', volume: 0.4);

  /// Game starting
  Future<void> playGameStart() => _play('game_start.wav', volume: 0.5);

  /// Game over
  Future<void> playGameOver() => _play('game_over.wav', volume: 0.5);

  /// Streak bonus
  Future<void> playStreak() => _play('streak.wav', volume: 0.45);

  /// Soft key click
  Future<void> playKeystroke() => _play('keystroke.wav', volume: 0.25);

  /// Star earned / celebration
  Future<void> playCelebration() => _play('streak.wav', volume: 0.6);

  /// Alias kept for backward compat
  Future<void> playStarEarned() => playCelebration();

  void dispose() {
    for (final pending in _voices.values) {
      pending.then((players) {
        for (final player in players) {
          player.dispose();
        }
      }).ignore();
    }
    _voices.clear();
    _nextVoice.clear();
    _audioAvailable = true;
  }
}
