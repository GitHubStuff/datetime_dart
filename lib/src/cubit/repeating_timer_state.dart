part of 'repeating_timer_cubit.dart';

///
/// This part of the file defines the state classes used by the [RepeatingTimerCubit]
/// for managing repeating timers. These state classes represent different states
/// that the timer can be in during its lifecycle.

/// An immutable base class representing the state of the repeating timer.
@immutable
sealed class RepeatingTimerState {
  /// The starting date and time of the timer state.
  final DateTime? startDateTime;

  /// Creates a [RepeatingTimerState] instance with an optional [startDateTime].
  const RepeatingTimerState(this.startDateTime);
}

/// Represents the state of the repeating timer when it is in the 'Interval' state.
///
/// The 'Interval' state indicates that the timer is currently active and
/// executing at regular intervals.
class RepeatingTimerInterval extends RepeatingTimerState {
  /// Creates a [RepeatingTimerInterval] instance with the provided [startDateTime].
  const RepeatingTimerInterval(DateTime super.startDateTime);
}

/// Represents the initial state of the repeating timer.
///
/// The 'Initial' state indicates that the timer has not started yet.
class RepeatingTimerInitial extends RepeatingTimerState {
  /// Creates a [RepeatingTimerInitial] instance.
  const RepeatingTimerInitial() : super(null);
}

/// Represents the state of the repeating timer when it is in the 'Off' state.
///
/// The 'Off' state indicates that the timer has been stopped and is not
/// currently active.
class RepeatingTimerOff extends RepeatingTimerState {
  /// Creates a [RepeatingTimerOff] instance with the provided [startDateTime].
  const RepeatingTimerOff(DateTime super.startDateTime);
}

/// Represents the state of the repeating timer when it is in the 'Started' state.
///
/// The 'Started' state indicates that the timer has been started and is awaiting
/// its first interval trigger.
class RepeatingTimerStarted extends RepeatingTimerState {
  /// Creates a [RepeatingTimerStarted] instance with the provided [startDateTime].
  const RepeatingTimerStarted(DateTime super.startDateTime);
}
