import 'dart:async';
import 'dart:developer' show log;
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

typedef OnAudio = void Function(Uint8List data);

class AudioStreamService {
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

  // ========== SENDER SIDE ==========

  Future<void> initRecorder() async {
    await _requestMicPermission();
    await _recorder.openRecorder();
  }

  Future<void> startListening(OnAudio onAudio) async {
    // Make a controller to receive PCM buffers
    final pcmController = StreamController<Uint8List>();

    // Start recording, streaming PCM data
    await _recorder.startRecorder(
      codec: Codec.pcm16, // using PCM16 (Int16) codec
      sampleRate: 16000, // typical for voice
      numChannels: 1, // mono
      toStream: pcmController.sink, // send data into this stream
      bufferSize: 256,
    );

    // Listen to the PCM stream and send over socket
    _pcmSubscription = pcmController.stream.listen(onAudio);
  }

  Future<void> stopListening() async {
    await _recorder.stopRecorder();
    await _pcmSubscription?.cancel();
  }

  // ========== RECEIVER SIDE ==========

  Future<void> initPlayer() async {
    await _player.openPlayer();
  }

  Future<void> startReceiving() async {
    // Set up player to accept data from stream
    await _player.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
      interleaved: true,
      bufferSize: 256,
    );
  }

  /// Call this when new PCM data arrives via socket
  Future<void> onDataReceived(Uint8List data) async {
    // feed data to player sink
    await _player.feedUint8FromStream(data);
    // (or .uint8ListSink.add(data) depending on API)
  }

  Future<void> stopReceiving() async {
    await _player.stopPlayer();
  }
}
