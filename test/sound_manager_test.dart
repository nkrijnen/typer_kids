import 'dart:async';
import 'dart:io';

import 'package:audioplayers_platform_interface/audioplayers_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/core/sound_manager.dart';

/// Records every platform call so tests can assert how often a source is set.
class _FakeAudioplayersPlatform extends AudioplayersPlatformInterface {
  final List<({String playerId, String method, Object? value})> calls = [];
  final Map<String, StreamController<AudioEvent>> _events = {};

  List<String> methodsNamed(String method) =>
      calls.where((c) => c.method == method).map((c) => c.playerId).toList();

  void _record(String playerId, String method, [Object? value]) =>
      calls.add((playerId: playerId, method: method, value: value));

  void _emit(String playerId, AudioEvent event) =>
      _events[playerId]?.add(event);

  Future<void> closeStreams() async {
    // Player disposal removes entries too, so snapshot before closing.
    final controllers = _events.values.toList();
    _events.clear();
    for (final controller in controllers) {
      await controller.close();
    }
  }

  @override
  Future<void> create(String playerId) async {
    _record(playerId, 'create');
    _events[playerId] = StreamController<AudioEvent>.broadcast();
  }

  @override
  Future<void> dispose(String playerId) async {
    _record(playerId, 'dispose');
    await _events.remove(playerId)?.close();
  }

  @override
  Stream<AudioEvent> getEventStream(String playerId) {
    _record(playerId, 'getEventStream');
    return _events[playerId]!.stream;
  }

  @override
  Future<void> setSourceUrl(
    String playerId,
    String url, {
    bool? isLocal,
    String? mimeType,
  }) async {
    _record(playerId, 'setSourceUrl', url);
    _emit(
      playerId,
      const AudioEvent(eventType: AudioEventType.prepared, isPrepared: true),
    );
  }

  @override
  Future<void> setSourceBytes(
    String playerId,
    Uint8List bytes, {
    String? mimeType,
  }) async {
    _record(playerId, 'setSourceBytes');
    _emit(
      playerId,
      const AudioEvent(eventType: AudioEventType.prepared, isPrepared: true),
    );
  }

  @override
  Future<void> resume(String playerId) async => _record(playerId, 'resume');

  @override
  Future<void> stop(String playerId) async => _record(playerId, 'stop');

  @override
  Future<void> pause(String playerId) async => _record(playerId, 'pause');

  @override
  Future<void> release(String playerId) async => _record(playerId, 'release');

  @override
  Future<void> seek(String playerId, Duration position) async =>
      _record(playerId, 'seek', position);

  @override
  Future<void> setVolume(String playerId, double volume) async =>
      _record(playerId, 'setVolume', volume);

  @override
  Future<void> setBalance(String playerId, double balance) async =>
      _record(playerId, 'setBalance', balance);

  @override
  Future<void> setReleaseMode(String playerId, ReleaseMode releaseMode) async =>
      _record(playerId, 'setReleaseMode', releaseMode);

  @override
  Future<void> setPlaybackRate(String playerId, double playbackRate) async =>
      _record(playerId, 'setPlaybackRate', playbackRate);

  @override
  Future<void> setPlayerMode(String playerId, PlayerMode playerMode) async =>
      _record(playerId, 'setPlayerMode', playerMode);

  @override
  Future<void> setAudioContext(String playerId, AudioContext ctx) async =>
      _record(playerId, 'setAudioContext', ctx);

  @override
  Future<int?> getDuration(String playerId) async {
    _record(playerId, 'getDuration');
    return 0;
  }

  @override
  Future<int?> getCurrentPosition(String playerId) async {
    _record(playerId, 'getCurrentPosition');
    return 0;
  }

  @override
  Future<void> emitLog(String playerId, String message) async =>
      _record(playerId, 'emitLog', message);

  @override
  Future<void> emitError(String playerId, String code, String message) async =>
      _record(playerId, 'emitError', code);
}

class _FakeGlobalAudioplayersPlatform
    extends GlobalAudioplayersPlatformInterface {
  final _events = StreamController<GlobalAudioEvent>.broadcast();

  @override
  Future<void> init() async {}

  @override
  Future<void> setGlobalAudioContext(AudioContext ctx) async {}

  @override
  Future<void> emitGlobalLog(String message) async {}

  @override
  Future<void> emitGlobalError(String code, String message) async {}

  @override
  Stream<GlobalAudioEvent> getGlobalEventStream() => _events.stream;
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  GlobalAudioplayersPlatformInterface.instance =
      _FakeGlobalAudioplayersPlatform();

  late _FakeAudioplayersPlatform platform;
  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('typer_kids_sfx_test');
    // AssetSource copies the asset to the temp directory before playing it.
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async =>
          call.method == 'getTemporaryDirectory' ? tempDir.path : null,
    );
  });

  tearDownAll(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    tempDir.deleteSync(recursive: true);
  });

  setUp(() {
    platform = _FakeAudioplayersPlatform();
    AudioplayersPlatformInterface.instance = platform;
    SoundManager().enabled = true;
  });

  tearDown(() async {
    SoundManager().dispose();
    await platform.closeStreams();
  });

  test('a sound loads its source once and replays without reloading', () async {
    // Regression: re-setting the source on every play leaked the native load
    // continuation on macOS/iOS and permanently wedged the player.
    await SoundManager().playPop();
    final afterFirst = platform.methodsNamed('setSourceUrl');
    expect(afterFirst, hasLength(2), reason: 'one load per preloaded voice');

    for (var i = 0; i < 10; i++) {
      await SoundManager().playPop();
    }

    expect(
      platform.methodsNamed('setSourceUrl'),
      afterFirst,
      reason: 'replaying must not set the source again',
    );
    expect(platform.methodsNamed('resume'), hasLength(11));
  });

  test('repeated plays alternate between the voices of that sound', () async {
    await SoundManager().playKeystroke();
    await SoundManager().playKeystroke();
    await SoundManager().playKeystroke();

    final resumed = platform.methodsNamed('resume');
    expect(resumed, hasLength(3));
    expect(resumed[0], isNot(resumed[1]), reason: 'second play uses voice two');
    expect(resumed[2], resumed[0], reason: 'third play wraps back to voice one');
  });

  test('each sound gets its own players', () async {
    await SoundManager().playCorrect();
    await SoundManager().playIncorrect();

    final sources = platform.calls
        .where((c) => c.method == 'setSourceUrl')
        .map((c) => c.value)
        .toSet();
    expect(sources, hasLength(2));
    expect(platform.methodsNamed('create').toSet(), hasLength(4));
  });

  test('concurrent first plays of one sound load it only once', () async {
    await Future.wait([
      SoundManager().playStreak(),
      SoundManager().playStreak(),
      SoundManager().playStreak(),
    ]);

    expect(platform.methodsNamed('setSourceUrl'), hasLength(2));
  });

  test('disabled sound touches no player at all', () async {
    SoundManager().enabled = false;
    await SoundManager().playPop();
    expect(platform.calls, isEmpty);
  });
}
