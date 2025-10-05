import 'dart:async';
import 'dart:developer' show log;
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

typedef OnAudio = void Function(Uint8List data);

class AudioStreamService {
  static final AudioStreamService _instance = AudioStreamService._internal();
  factory AudioStreamService() => _instance;
  AudioStreamService._internal();

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  StreamSubscription? _pcmSubscription;

  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      log("Microphone permission granted");
    } else {
      log("Microphone permission denied");
    }
  }

  Future<void> initRecorder() async {
    await _requestMicPermission();
    await _recorder.openRecorder();
  }

  Future<void> startMicRecording(OnAudio onAudio) async {
    final pcmController = StreamController<Uint8List>();
    await _recorder.startRecorder(
      codec: Codec.pcm16,
      sampleRate: 16000,
      numChannels: 1,
      toStream: pcmController.sink,
      bufferSize: 256,
    );

    _pcmSubscription = pcmController.stream.listen(onAudio);
  }

  Future<void> stopListening() async {
    await _recorder.stopRecorder();
    await _pcmSubscription?.cancel();
  }

  Future<void> initPlayer() async {
    await _player.openPlayer();
  }

  Future<void> startReceiving() async {
    await _player.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
      interleaved: true,
      bufferSize: 256,
    );
  }

  Future<void> onDataReceived(Uint8List data) async {
    await _player.feedUint8FromStream(data);
  }

  Future<void> stopReceiving() async {
    await _player.stopPlayer();
  }
}
