import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// Instrumentation for the "buttons and keys stop responding after a long
/// session" report (backlog bug 9).
///
/// A heartbeat line carries enough state to tell the failure modes apart:
/// if the heartbeat stops the UI thread is wedged; if it continues while taps
/// climb and nothing happens, input is arriving but being swallowed, and the
/// focus and route fields say by what.
///
/// On in debug builds, or with `--dart-define=typer_diagnostics=true`.
class InputDiagnostics {
  InputDiagnostics._();

  static const bool enabled =
      kDebugMode || bool.fromEnvironment('typer_diagnostics');

  static const Duration _beat = Duration(seconds: 5);
  static const int _slowFrameMs = 500;

  static final RouteDepthObserver routeObserver = RouteDepthObserver();

  static bool _installed = false;
  static final Stopwatch _uptime = Stopwatch();
  static Timer? _timer;

  static int _taps = 0;
  static int _keys = 0;
  static int _errors = 0;
  static int _frames = 0;
  static int _worstFrameMs = 0;
  static Duration _lastTapAt = Duration.zero;
  static Duration _lastKeyAt = Duration.zero;

  static void install() {
    if (!enabled || _installed) return;
    // flutter_test owns error reporting and fails on timers that outlive a
    // test, so instrumentation must stay out of the way under a test binding.
    if (WidgetsBinding.instance is! WidgetsFlutterBinding) return;
    _installed = true;
    _uptime.start();

    final priorOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      _errors++;
      _log('FlutterError: ${details.exceptionAsString()}');
      priorOnError?.call(details);
    };

    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      _errors++;
      _log('uncaught: $error');
      return false;
    };

    // Counts every key the engine delivers, even when no listener handles it.
    HardwareKeyboard.instance.addHandler((event) {
      if (event is KeyDownEvent) {
        _keys++;
        _lastKeyAt = _uptime.elapsed;
      }
      return false;
    });

    SchedulerBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        _frames++;
        final ms = timing.totalSpan.inMilliseconds;
        if (ms > _worstFrameMs) _worstFrameMs = ms;
        if (ms >= _slowFrameMs) {
          _log(
            'slow frame ${ms}ms'
            ' build=${timing.buildDuration.inMilliseconds}ms'
            ' raster=${timing.rasterDuration.inMilliseconds}ms',
          );
        }
      }
    });

    _timer = Timer.periodic(_beat, (_) => _heartbeat());
    _log('diagnostics on');
  }

  static void stop() {
    _timer?.cancel();
    _timer = null;
    _installed = false;
    _uptime.stop();
  }

  /// Wraps the app so raw pointer arrivals are counted before any widget
  /// decides what to do with them.
  static Widget wrap(Widget child) {
    if (!enabled) return child;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _taps++;
        _lastTapAt = _uptime.elapsed;
      },
      child: child,
    );
  }

  static void _heartbeat() {
    final focus = FocusManager.instance.primaryFocus;
    _log(
      'alive ${_uptime.elapsed.inSeconds}s'
      ' frames=$_frames worst=${_worstFrameMs}ms'
      ' taps=$_taps(${_agoOf(_lastTapAt)})'
      ' keys=$_keys(${_agoOf(_lastKeyAt)})'
      ' errors=$_errors'
      ' routes=${routeObserver.depth}/${routeObserver.top}'
      ' focus=${_describe(focus)}',
    );
    _frames = 0;
    _worstFrameMs = 0;
  }

  static String _agoOf(Duration at) =>
      at == Duration.zero ? 'never' : '${(_uptime.elapsed - at).inSeconds}s ago';

  static String _describe(FocusNode? node) {
    if (node == null) return 'none';
    final widget = node.context?.widget.runtimeType;
    final label = node.debugLabel ?? widget?.toString() ?? node.runtimeType;
    return '$label'
        '${node.hasPrimaryFocus ? '' : ' !primary'}'
        '${node.canRequestFocus ? '' : ' !canRequest'}'
        '${node.context == null ? ' detached' : ''}';
  }

  static void _log(String message) => debugPrint('[diag] $message');
}

/// Tracks how deep the navigator stack is, so a dialog or route that never
/// popped shows up as a depth that only ever grows.
class RouteDepthObserver extends NavigatorObserver {
  int depth = 0;
  String top = 'none';

  String _name(Route<dynamic>? route) =>
      route?.settings.name ?? route?.runtimeType.toString() ?? 'none';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    depth++;
    top = _name(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    depth--;
    top = _name(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    depth--;
    top = _name(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    top = _name(newRoute);
  }
}
