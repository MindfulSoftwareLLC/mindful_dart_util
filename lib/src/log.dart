import 'package:logging/logging.dart';

///Simplest logging for an app.  It uses an "App" logger
///and static methods so Log.info(msg), etc
class Log {
  static final Logger _logger = Logger('App');

  ///Setup logger configuration.
  void setup() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen(
      (LogRecord rec) {
        // ignore: avoid_print
        print(
          '[${rec.time} | ${rec.loggerName} | ${rec.level.name}] '
          '${rec.message}',
        );
      },
    );
  }

  ///Log info message.
  static void info(String message) {
    _logger.info(message);
  }

  ///Log fine message.
  static void fine(String message) {
    _logger.fine(message);
  }

  ///Log warning message.
  static void warning(String message) {
    _logger.warning(message);
  }

  ///Log severe mesasge.
  static void severe(String message) {
    _logger.severe(message);
  }
}
