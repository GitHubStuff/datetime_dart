library;

/// Constants and extensions for numeric conversions related to time units.
///
/// This module defines constants for common time unit conversions and provides
/// extensions to easily convert numeric values between different time units.

/// The number of months in a year.
const num monthsPerYear = 12;

/// The number of hours in a day.
const num hoursPerDay = 24;

/// The number of minutes in an hour.
const num minutesPerHour = 60;

/// The number of seconds in a minute.
const num secondsPerMinute = 60;

/// The number of milliseconds in a second.
const num msecondsPerSecond = 1000;

/// The number of microseconds in a millisecond.
const num usecondsPerMillisecond = 1000;

/// Extension on numeric values to convert to months.
extension NumExt on num {
  /// Converts the numeric value to months.
  ///
  /// This extension multiplies the numeric value by the constant [monthsPerYear]
  /// to convert it to months.
  num asMonths() => (this * monthsPerYear);

  /// Converts the numeric value to hours.
  ///
  /// This extension multiplies the numeric value by the constant [hoursPerDay]
  /// to convert it to hours.
  num asHours() => (this * hoursPerDay);

  /// Converts the numeric value to minutes.
  ///
  /// This extension multiplies the numeric value by the constant [minutesPerHour]
  /// to convert it to minutes.
  num asMinutes() => (this * minutesPerHour);

  /// Converts the numeric value to seconds.
  ///
  /// This extension multiplies the numeric value by the constant [secondsPerMinute]
  /// to convert it to seconds.
  num asSeconds() => (this * secondsPerMinute);

  /// Converts the numeric value to milliseconds.
  ///
  /// This extension multiplies the numeric value by the constant [msecondsPerSecond]
  /// to convert it to milliseconds.
  num asMilliseconds() => (this * msecondsPerSecond);

  /// Converts the numeric value to microseconds.
  ///
  /// This extension multiplies the numeric value by the constant [usecondsPerMillisecond]
  /// to convert it to microseconds.
  num asMicroseconds() => (this * usecondsPerMillisecond);
}
