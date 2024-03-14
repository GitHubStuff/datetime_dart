/// A Dart package that provides a [RepeatingTimerCubit] class for managing
/// repeating timers with customizable intervals.
///
/// This package is built on top of Flutter's BLoC (Business Logic Component)
/// architecture and utilizes the `dart:async` library for timer functionality.
///
/// To use this package, import it and create an instance of [RepeatingTimerCubit].
/// You can start and stop the timer using the provided methods.
///
/// Example usage:
///
/// ```dart
///  RepeatingTimerCubit timer = RepeatingTimerCubit();
///
/// Start the timer with a custom repeating interval (default is 1 second).
/// timer.start(repeatingDateTimeUnit: DateTimeUnit.minute);
///
/// Stop the timer when you're done.
/// timer.stop();
/// ```
library repeating_timer;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../date_time/datetime_ext.dart';
import '../date_time/datetime_unit.dart';

part 'repeating_timer_state.dart';

/// The default repeating interval unit for the timer.
const _kDefaultInterval = DateTimeUnit.second;

/// A BLoC (Business Logic Component) class for managing repeating timers.
///
/// Use this class to create and control repeating timers with customizable
/// intervals. You can start and stop the timer as needed.
class RepeatingTimerCubit extends Cubit<RepeatingTimerState> {
  late final DateTime _systemDateTime;
  Timer? _timer;

  /// Creates a [RepeatingTimerCubit] instance.
  ///
  /// You can optionally provide a [systemDateTime] to initialize the timer's
  /// reference time. By default, the system's current time is used.
  RepeatingTimerCubit({DateTime? systemDateTime})
      : _systemDateTime = makeUtc(systemDateTime, round: DateTimeUnit.usec),
        super(const RepeatingTimerInitial());

  /// Starts the repeating timer with the specified interval.
  ///
  /// The [repeatingDateTimeUnit] parameter determines the interval at which
  /// the timer triggers. It should be a value from the [DateTimeUnit] enum.
  ///
  /// Example:
  /// ```dart
  /// RepeatingTimerCubit timer = RepeatingTimerCubit();
  ///
  /// Start the timer with a custom repeating interval (default is 1 second).
  /// timer.start(repeatingDateTimeUnit: DateTimeUnit.minute);
  /// ```
  void start({DateTimeUnit repeatingDateTimeUnit = _kDefaultInterval}) {
    repeatingDateTimeUnit.checkPrecision();
    DateTime triggerDateTime = makeUtc(
        _systemDateTime.nextInterval(
          onType: repeatingDateTimeUnit,
          setToLastDay: true,
        ),
        round: repeatingDateTimeUnit.next);

    emit(RepeatingTimerStarted(triggerDateTime));

    Duration duration = triggerDateTime.difference(_systemDateTime);
    _timer = Timer.periodic(duration, (timer) {
      emit(RepeatingTimerInterval(triggerDateTime));
      DateTime nextTriggerDateTime = makeUtc(
          triggerDateTime.nextInterval(
            onType: repeatingDateTimeUnit,
            setToLastDay: true,
          ),
          round: repeatingDateTimeUnit.next);
      duration = nextTriggerDateTime.difference(triggerDateTime);
      triggerDateTime = nextTriggerDateTime;
    });
  }

  /// Stops the repeating timer if it is running.
  ///
  /// If the timer is not running (i.e., its state is [RepeatingTimerOff]),
  /// this method does nothing.
  void stop() {
    if (state is RepeatingTimerOff) return;
    _timer?.cancel();
    _timer = null;
    emit(RepeatingTimerOff(state.startDateTime!));
  }
}
