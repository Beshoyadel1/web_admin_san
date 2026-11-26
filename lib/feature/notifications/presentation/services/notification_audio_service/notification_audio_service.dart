import '../../../../../../core/services/audio_service/audio_service.dart';

class NotificationAudioService {
  const NotificationAudioService();

  Future<void> play() async {
    await AudioService.instance.playChime();
  }

  Future<void> stop() async {
    await AudioService.instance.stopNotificationSound();
  }
}
