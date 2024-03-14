# datetime_dart

## Features

**RepeatingTimerCubit**: A BLoC (Business Logic Component) class for managing repeating timers.

***DateTime* extensions**: A collection of utility functions and extensions for working with date and time in Dart.

**DateTimeInterval**: A utility class for calculating the interval between two DateTime objects. Including years and months, beyond the features of *Duration()*.

**DateTimeUnit**: Enum for parts of DateTime() [*(year, month, day hour, minute second, msec, usec)*]. And several methods for formatting *DateTime()*, and other helper methods to precisely calculate intervals with various rounding and percision.

**DateTimeAlarm**: A Dart class for creating and managing date and time alarms.

**DateTimeToast**: A utility class for displaying toast notifications with date and time information. *See* [datetime_toast.dart](lib/widgets/datetime_toast.dart) for setup instructions!

## Getting started

If using **DateTimeToast** the following needs to be added to *main.dart*:

```dart
// Import package
import 'package:datetime_dart/datetime_dart.dart';

    :
    :
    
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ModularApp(
      module: AppModule(),
      // Wrap the first widget with DateTimeToast.setUp()
      child: DateTimeToast.setUp(child: const MyApp()),
    ),
  );
}
```

**/example/lib/screen/home_scaffold.dart** has an example of how to setup an alarm:

```dart
/// Declare an alarm
DateTimeAlarm? myAlarm;

/// 1 - In code create an alarm
/// 2 - Start the alarm
/// 3 - Listen for the alarm
/// 4 - Stop the alarm



   if (myAlarm == null) {
      // 1 - CREATE
      myAlarm = DateTimeAlarm(
        alarmDateTime:
            systemTime.add(const Duration(seconds: 7)), // Set the alarm time
        truncatedTimeUnit: DateTimeUnit.msec,
        systemDateTime: systemTime, // Customize time precision
      );
      
      // 2 - START
      myAlarm?.start();
      debugPrint('Alarm triggered at $systemTime');
      
      // 3 - LISTEN
      myAlarm?.onAlarm.listen((dateTime) {
        if (dateTime != null) {
          debugPrint('Alarm triggered at $dateTime');
          DateTimeToast().show(message: 'Now is $dateTime');
        } else {
          debugPrint('Alarm stopped');
        }
      });
      
      // 4 - STOP
      Future.delayed(const Duration(seconds: 20), () {
        myAlarm?.stop();
      });
    }
```

## Usage

*NOTE: See **/example** for more*

Add to **pubspec.yaml**

```yaml
dependencies:
  datetime_dart:
    git: https://github.com/GitHubStuff/datetime_dart.git
```

```dart
RepeatingTimerCubit rtc = RepeatingTimerCubit();
rtc.start();  //Start repeating intervals
rtc.stop(); //Stop repeating

//if time == null returns current time as utc
DateTime utc = makeUtc(DateTime? time); 

//if time == null returns current local time
DateTime local = makeLocal(DateTime? time);

// Truncates the DateTime to the specified DateTimeUnit precision.
// Default is microsecond.
DateTime? trunk = time?.truncate(at: DateTimeUnit.msec);

// Formatted String (DateTime ext)
// const kDefautlFormatString = 'EEE d-MMM-yyyy h:mm:ss a';
String formattedDateTime = dateTime.formatted(String format = kDefautlFormatString,
    bool asUtc = false,);

```

## Note

There many more methods and features that help with measuring tasks related to **DateTime()**, its intervals, durations, alarms, event notifications, and states.

There is alot of methods that allow for a ***systemDateTime*** parameter.. This is to allow for setting the time to fixed value for unit and integration testing

## Additional information

This repo is hosted on GitHub: [datetime_dart](https://github.com/GitHubStuff/datetime_dart.git). Please comment and report issues there.

## Finally

Be kind to each other.
