import 'package:cryptochat/features/auth/constants/caudio.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioEffectService {
  static final AudioEffectService _instance = AudioEffectService._internal();
  factory AudioEffectService() => _instance;
  AudioEffectService._internal();

  final SoLoud _player = SoLoud.instance;
  SoundHandle? _handle;

  Future<void> stop() async => _stopCurrent();

  Future<void> _init() async {
    if (_player.isInitialized) return;
    await _player.init();
  }

  Future<void> dispose() async {
    if (!_player.isInitialized) return;
    await _player.disposeAllSources();
  }

  Future<void> playConnecting() async {
    // dial up
    _play(CAudio.connecting);
  }

  Future<void> playRinging() async {
    // ringback
    _play(CAudio.ringback);
  }

  Future<void> playRingtone() async {
    // facebook call
    _play(CAudio.ringtone);
  }

  Future<void> _stopCurrent() async {
    if (_handle != null) await _player.stop(_handle!);
  }

  Future<void> _play(String path) async {
    await _init();
    await _stopCurrent();
    final AudioSource source = await _player.loadAsset(path);
    _handle = await _player.play(source, looping: true);
  }
}
