import 'package:intl/intl.dart';

import '../../datetime_dart.dart';

/// A collection of utility functions and extensions for working with date and time in Dart.
///
/// This module includes functions for creating and manipulating DateTime objects,
/// as well as extensions to the DateTime class to provide additional functionality.
///
/// Example usage:
///
/// ```dart
/// DateTime now = DateTime.now();
/// DateTime tomorrow = now.addToDay(1);
/// int daysInCurrentMonth = now.daysInMonth;
/// ```
/// Creates a DateTime object with the specified DateTimeUnit precision.
///
/// - [dateTime]: The DateTime object to be rounded (default is the current system time).
/// - [round]: The DateTimeUnit at which the DateTime should be rounded (default is milliseconds).
DateTime makeLocal(
  DateTime? dateTime, {
  DateTimeUnit round = DateTimeUnit.msec,
}) =>
    ((dateTime == null) ? DateTime.now().toLocal() : dateTime.toLocal())
        .truncate(
      at: round,
    );

/// Creates a UTC DateTime object with the specified DateTimeUnit precision.
///
/// - [dateTime]: The DateTime object to be rounded (default is the current system time).
/// - [round]: The DateTimeUnit at which the DateTime should be rounded (default is milliseconds).
DateTime makeUtc(
  DateTime? dateTime, {
  DateTimeUnit round = DateTimeUnit.msec,
}) {
  if (dateTime == null) return DateTime.now().toUtc().truncate(at: round);
  if (dateTime.isUtc) return dateTime.truncate(at: round);
  Set<DateTimeUnit> itemSet = round.setFrom();
  assert(itemSet.isNotEmpty, 'itemSet must not be empty');
  return DateTime(
    itemSet.contains(DateTimeUnit.year) ? 0 : dateTime.year,
    itemSet.contains(DateTimeUnit.month) ? 1 : dateTime.month,
    itemSet.contains(DateTimeUnit.day) ? 1 : dateTime.day,
    itemSet.contains(DateTimeUnit.hour) ? 0 : dateTime.hour,
    itemSet.contains(DateTimeUnit.minute) ? 0 : dateTime.minute,
    itemSet.contains(DateTimeUnit.second) ? 0 : dateTime.second,
    itemSet.contains(DateTimeUnit.msec) ? 0 : dateTime.millisecond,
    itemSet.contains(DateTimeUnit.usec) ? 0 : dateTime.microsecond,
  ).toUtc();
}

extension DateTimeExt on DateTime {
  String formatted({
    String format = kDefautlFormatString,
    bool asUtc = false,
  }) =>
      DateFormat(format).format(asUtc ? makeUtc(this) : makeLocal(this));

  /// An extension for the DateTime class providing additional functionality.
  /// Returns the number of days in the month and accounts for leap years.
  int get daysInMonth => [
        0,
        31,
        isLeapYear() ? 29 : 28,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31
      ][month];

  /// Returns a new DateTime with the given number of months added.
  DateTime addToMonth(num months, {bool setToLastDay = true}) {
    DateTime returnDateTime = toUtc();
    if (months == 0) return this;
    if (months < 0) {
      while (months < 0) {
        months++;
        returnDateTime = returnDateTime._subtractMonth(
          returnDateTime,
          setToLastDay: setToLastDay,
        );
      }
    } else {
      while (months > 0) {
        months--;
        returnDateTime = returnDateTime._addMonth(
          returnDateTime,
          setToLastDay: setToLastDay,
        );
      }
    }
    return returnDateTime;
  }

  /// Returns a new DateTime with the given number of years added.
  DateTime addToYear(int years, {bool setToLastDay = true}) => addToMonth(
        years * DateTime.monthsPerYear,
        setToLastDay: setToLastDay,
      );

  /// Returns the Interval between this DateTime and a target DateTime.
  DateTimeInterval interval(
          {DateTime? targetDateTime,
          DateTimeUnit roundedTo = DateTimeUnit.year}) =>
      DateTimeInterval(
        startEvent: this,
        endEvent: targetDateTime ?? DateTime.now(),
        roundedTo: roundedTo,
      );

  /// Returns true/false if the year is a leap year.
  bool isLeapYear() => (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  /// Returns true/false if the DateTime is the last day of the month.
  bool isLastDayOfMonth() => day == daysInMonth;

  /// Returns a new DateTime representing the next interval based on DateTimeUnit.
  DateTime nextInterval(
          {required DateTimeUnit onType, bool setToLastDay = true}) =>
      _updateInterval(onType: onType, setToLastDay: setToLastDay, amount: 1);

  /// Returns a new DateTime representing the previous interval based on DateTimeUnit.
  DateTime previousInterval(
          {required DateTimeUnit onType, bool setToLastDay = true}) =>
      _updateInterval(onType: onType, setToLastDay: setToLastDay, amount: -1);

  /// Truncates the DateTime to the specified DateTimeUnit precision.
  DateTime truncate({DateTimeUnit at = DateTimeUnit.msec}) {
    Set<DateTimeUnit> itemSet = at.setFrom();
    assert(itemSet.isNotEmpty, 'itemSet must not be empty');
    final m = isUtc ? DateTime.utc : DateTime.new;
    return m(
      itemSet.contains(DateTimeUnit.year) ? 0 : year,
      itemSet.contains(DateTimeUnit.month) ? 1 : month,
      itemSet.contains(DateTimeUnit.day) ? 1 : day,
      itemSet.contains(DateTimeUnit.hour) ? 0 : hour,
      itemSet.contains(DateTimeUnit.minute) ? 0 : minute,
      itemSet.contains(DateTimeUnit.second) ? 0 : second,
      itemSet.contains(DateTimeUnit.msec) ? 0 : millisecond,
      itemSet.contains(DateTimeUnit.usec) ? 0 : microsecond,
    );
  }

  DateTime _updateInterval(
      {required DateTimeUnit onType,
      required bool setToLastDay,
      required int amount}) {
    switch (onType) {
      case DateTimeUnit.year:
        return addToYear(amount, setToLastDay: setToLastDay);
      case DateTimeUnit.month:
        return addToMonth(amount, setToLastDay: setToLastDay);
      case DateTimeUnit.day:
        return add(Duration(days: amount));
      case DateTimeUnit.hour:
        return add(Duration(hours: amount));
      case DateTimeUnit.minute:
        return add(Duration(minutes: amount));
      case DateTimeUnit.second:
        return add(Duration(seconds: amount));
      case DateTimeUnit.msec:
        return add(Duration(milliseconds: amount));
      case DateTimeUnit.usec:
        return add(Duration(microseconds: amount));
    }
  }

  DateTime _addMonth(DateTime start, {bool setToLastDay = true}) {
    int newMonth = start.month + 1;
    final int newYear =
        start.year + (newMonth > DateTime.monthsPerYear ? 1 : 0);
    newMonth = newMonth > DateTime.monthsPerYear ? DateTime.january : newMonth;
    setToLastDay = setToLastDay && start.day == start.daysInMonth;
    int newDay =
        setToLastDay ? DateTime(newYear, newMonth + 1, 0).day : start.day;

    return DateTime.utc(
      newYear,
      newMonth,
      newDay,
      start.hour,
      start.minute,
      start.second,
      start.millisecond,
      start.microsecond,
    );
  }

  DateTime _subtractMonth(DateTime back, {bool setToLastDay = true}) {
    int newMonth = back.month - 1;
    final int newYear = newMonth < DateTime.january ? back.year - 1 : back.year;
    newMonth = newMonth < DateTime.january ? DateTime.monthsPerYear : newMonth;
    final int newDay =
        setToLastDay ? DateTime(newYear, newMonth + 1, 0).day : back.day;
    return DateTime.utc(
      newYear,
      newMonth,
      newDay,
      back.hour,
      back.minute,
      back.second,
      back.millisecond,
      back.microsecond,
    );
  }
}
