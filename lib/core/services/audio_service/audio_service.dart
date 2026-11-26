import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();

  /// Plays a single-shot chime alert for incoming support tickets and chat messages.
  Future<void> playChime() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.release);
      await _player.play(AssetSource("sounds/notification.mp3"));
    } catch (e) {
      if (kDebugMode) {
        debugPrint("AudioService chime error: $e");
      }
    }
  }

  /// Starts a continuous looping sound alert for urgent new orders until dismissed.
  Future<void> startNotificationSound() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource("sounds/notification.mp3"));
    } catch (e) {
      if (kDebugMode) {
        debugPrint("AudioService looping alert error: $e");
      }
    }
  }

  /// Stops any currently playing notification sound.
  Future<void> stopNotificationSound() async {
    try {
      await _player.stop();
      await _player.setReleaseMode(ReleaseMode.release);
    } catch (e) {
      if (kDebugMode) {
        debugPrint("AudioService stop error: $e");
      }
    }
  }
}
