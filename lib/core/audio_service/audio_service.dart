import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playNotification() async {
    await _player.stop();

    await _player.play(
      AssetSource("sounds/notification.mp3"),
    );
  }
}