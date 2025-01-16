import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

// ignore: avoid_classes_with_only_static_members
///
/// Tip: Use the plugin Grep Console to get some color into your logs!
/// The colors of the SimplePrinter (ansi codes) don't work in Android Studio
///
class Log {
  static Logger get _logger => Logger(
        printer: _Printer(),
        output: _ConsoleOutput(),
      );

  static void v(dynamic msg) => _logger.t(msg);

  static void d(dynamic msg) => _logger.d(msg);

  static void i(dynamic msg) => _logger.i(msg);

  static void json(dynamic msg) {
    try {
      final encoder = JsonEncoder.withIndent('  ');
      final prettyString = encoder.convert(msg);
      _logger.t('[JSON]\n$prettyString');
    } catch (e) {
      Log.e('Failed to decode JSON: $msg', e, null);
    }
  }

  static void w(dynamic msg, [Object? error, StackTrace? stackTrace]) => _logger.w(msg, error: error, stackTrace: stackTrace);

  static void e(dynamic msg, Object error, StackTrace? stackTrace) => _logger.e(msg, error: error, stackTrace: stackTrace);
}

class _ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      log(line, level: event.level.value, time: DateTime.now(), name: 'App');
    }
  }
}

/// Outputs simple log messages:
/// ```
/// [E] Log message  ERROR: Error info
/// ```
class _Printer extends LogPrinter {
  _Printer();

  static final levelPrefixes = {
    Level.trace: '[T]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.fatal: '[FATAL]',
  };

  // https://user-images.githubusercontent.com/995050/47952855-ecb12480-df75-11e8-89d4-ac26c50e80b9.png
  // 265 color reference
  static final levelColors = {
    Level.trace: AnsiColor.fg(31),
    Level.debug: AnsiColor.fg(27),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.fatal: AnsiColor.fg(199),
  };

  @override
  List<String> log(LogEvent event) {
    final messageStr = _stringifyMessage(event.message);
    final errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    final timeStr = DateFormat('H:mm:ss.S').format(event.time);

    final color = levelColors[event.level]!;
    return [color('${levelPrefixes[event.level]} $timeStr $messageStr$errorStr')];
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      const encoder = JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
