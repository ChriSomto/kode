import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// Global instance — initialized once in main.dart
AudioHandler? audioHandler;

Future<void> initAudioService() async {
  audioHandler = await AudioService.init(
    builder: () => GradclockAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.gradclock.audio',
      androidNotificationChannelName: 'gradclock',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class GradclockAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  static const String _songPath = 'assets/audio/song.mp3';
  bool _loaded = false;

  GradclockAudioHandler() {
    // Forward player state to audio_service
    _player.playbackEventStream.listen(_broadcastState);
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stop();
      }
    });
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(playbackState.value.copyWith(
      controls: [
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      playing: playing,
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
    ));
  }

  @override
  Future<void> play() async {
    try {
      if (!_loaded) {
        await _player.setAsset(_songPath);
        _loaded = true;
      }
      await _player.play();
    } catch (e) {
      _loaded = false;
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _loaded = false;
    await super.stop();
  }

  bool get isPlaying => _player.playing;
}