import 'package:intl/intl.dart';

import 'datetime_ext.dart';

extension StringDateTimeUnit on String {
  DateTimeUnit dateTimeUnit() {
    for (DateTimeUnit unit in DateTimeUnit.values) {
      if (unit.name == this) return unit;
    }
    throw ArgumentError('Invalid DateTimeUnit $this');
  }
}

/// Enum for DateTime fields/properties
enum DateTimeUnit {
  year,
  month,
  day,
  hour,
  minute,
  second,
  msec,
  usec;

  /// A map of default formats for each DateTimeUnit
  static const Map<DateTimeUnit, String> _defaultFormats = {
    DateTimeUnit.year: '0000',
    DateTimeUnit.month: '00',
    DateTimeUnit.day: '00',
    DateTimeUnit.hour: '00',
    DateTimeUnit.minute: '00',
    DateTimeUnit.second: '00',
    DateTimeUnit.msec: '000000',
    DateTimeUnit.usec: '000',
  };

  /// Returns a NumberFormat for the current DateTimeUnit
  /// If a NumberFormat is provided, it will be returned.
  /// Otherwise, a default format will be used.
  NumberFormat format({NumberFormat? numberFormat}) {
    return numberFormat ?? NumberFormat(_defaultFormats[this]!);
  }

  /// Checks if the current DateTimeUnit is in the provided exclusion set
  /// If it is, an ArgumentError is thrown
  void checkPrecision({
    Set<DateTimeUnit> exclusionSet = const {
      DateTimeUnit.msec,
      DateTimeUnit.usec,
    },
  }) {
    if (exclusionSet.contains(this)) {
      throw ArgumentError('$name cannot be used as a DateTimeUnit');
    }
  }

  /// Returns a set of DateTimeUnits from the current DateTimeUnit to the last DateTimeUnit
  Set<DateTimeUnit> setFrom() {
    final index = DateTimeUnit.values.indexOf(this);
    return Set<DateTimeUnit>.from(DateTimeUnit.values.sublist(index));
  }

  /// Returns the next DateTimeUnit from the current DateTimeUnit
  /// If the current DateTimeUnit is the last one, it will return itself
  DateTimeUnit get next {
    final index = DateTimeUnit.values.indexOf(this);
    if (index == DateTimeUnit.values.length - 1) return this;
    return DateTimeUnit.values[index + 1];
  }

  /// Returns a Duration representing the current DateTimeUnit
  Duration duration({int? year, int? month}) {
    final utc = DateTime.now().toUtc();
    year ??= utc.year;
    month ??= utc.month;
    switch (this) {
      case DateTimeUnit.year:
        return Duration(days: utc.isLeapYear() ? 366 : 365);
      case DateTimeUnit.month:
        return Duration(days: DateTime(year, month + 1, 0).day);
      case DateTimeUnit.day:
        return const Duration(days: 1);
      case DateTimeUnit.hour:
        return const Duration(hours: 1);
      case DateTimeUnit.minute:
        return const Duration(minutes: 1);
      case DateTimeUnit.second:
        return const Duration(seconds: 1);
      case DateTimeUnit.msec:
        return const Duration(milliseconds: 1);
      case DateTimeUnit.usec:
        return const Duration(microseconds: 1);
    }
  }
}

/// Enum for representing the relation between two DateTime values
enum DateTimeRelation {
  before,
  now,
  after;

  /// Returns the relation between startEvent and endEvent
  /// If startEvent is before endEvent, it returns DateTimeRelation.before
  /// If startEvent is after endEvent, it returns DateTimeRelation.after
  /// If startEvent is the same as endEvent, it returns DateTimeRelation.now
  static DateTimeRelation direction(DateTime startEvent, DateTime endEvent) {
    if (startEvent.isBefore(endEvent)) return DateTimeRelation.before;
    if (startEvent.isAfter(endEvent)) return DateTimeRelation.after;
    return DateTimeRelation.now;
  }
}
