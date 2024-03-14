import 'dart:async';

import '../date_time/datetime_ext.dart';
import '../date_time/datetime_unit.dart';

/// A Dart class for creating and managing date and time alarms.
///
/// The [DateTimeAlarm] class allows you to set a specific alarm date and time
/// and receive notifications when the alarm time is reached. You can customize
/// the granularity of the alarm time using the [truncatedTimeUnit] parameter.
///
/// Example usage:
///
/// ```dart
/// DateTimeAlarm myAlarm = DateTimeAlarm(
///   alarmDateTime: DateTime(2024, 1, 15, 12, 0), // Set the alarm time
///   truncatedTimeUnit: DateTimeUnit.second, // Customize time precision
/// );
///
/// Start the alarm and listen for notifications
/// myAlarm.start();
/// myAlarm.onAlarm.listen((dateTime) {
///   if (dateTime != null) {
///     print('Alarm triggered at $dateTime');
///   } else {
///     print('Alarm stopped');
///   }
/// });
///
/// Stop the alarm when no longer needed
/// myAlarm.stop();
/// ```
class DateTimeAlarm {
  /// The granularity of the alarm time. Determines the precision of the alarm.
  final DateTimeUnit truncatedTimeUnit;

  final StreamController<DateTime?> _controller = StreamController<DateTime?>();
  late final DateTime _systemDateTime;
  late final DateTime alarmDateTime;
  Timer? _timer;

  /// Creates a [DateTimeAlarm] instance with the specified parameters.
  ///
  /// - [alarmDateTime]: The date and time when the alarm should trigger.
  /// - [truncatedTimeUnit]: The precision of the alarm time (default is milliseconds).
  /// - [systemDateTime]: An optional system date and time reference (default is current system time).
  DateTimeAlarm({
    required DateTime alarmDateTime,
    this.truncatedTimeUnit = DateTimeUnit.msec,
    DateTime? systemDateTime,
  }) {
    this.alarmDateTime = makeUtc(alarmDateTime, round: truncatedTimeUnit);
    _systemDateTime = makeUtc(systemDateTime, round: truncatedTimeUnit);
  }

  /// Gets the duration remaining until the alarm triggers.
  Duration get durationToAlarm => alarmDateTime.difference(_systemDateTime);

  /// Calculates a hash code based on alarm properties.
  int hash() =>
      alarmDateTime.hashCode ^
      truncatedTimeUnit.hashCode ^
      _systemDateTime.hashCode;

  /// A stream that emits the alarm date and time when it triggers.
  Stream<DateTime?> get onAlarm => _controller.stream;

  /// Starts the alarm timer and schedules notifications.
  ///
  /// The alarm timer is set to trigger when the specified [alarmDateTime] is reached.
  void start() {
    _cancelTimer();
    final duration = alarmDateTime.isBefore(_systemDateTime)
        ? _systemDateTime.millisecondsSinceEpoch -
            alarmDateTime.millisecondsSinceEpoch
        : alarmDateTime.millisecondsSinceEpoch -
            _systemDateTime.millisecondsSinceEpoch;
    _timer = Timer(Duration(milliseconds: duration), () {
      _controller.sink.add(alarmDateTime);
    });
  }

  /// Stops the alarm and closes the notification stream.
  ///
  /// This method stops the alarm timer and closes the stream. After calling
  /// this method, no more notifications will be emitted.
  void stop() {
    _controller.sink.add(null);
    _cancelTimer();
    _controller.close();
  }

  /// Cancels the internal timer if it is active.
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
