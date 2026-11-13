import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer()..audioCache.prefix = '';
  AudioService();

  Future<void> playAudio(String soundPath) async {
    await _player.play(AssetSource(soundPath));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
