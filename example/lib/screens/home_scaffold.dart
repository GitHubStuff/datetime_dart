// ignore_for_file: sort_child_properties_last

import 'package:datetime_dart/datetime_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../gen/assets.gen.dart';

final DateTime systemTime = DateTime(2021, 1, 1, 12, 14, 1).toUtc();

DateTimeAlarm? myAlarm;

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    if (myAlarm == null) {
      myAlarm = DateTimeAlarm(
        alarmDateTime:
            systemTime.add(const Duration(seconds: 7)), // Set the alarm time
        truncatedTimeUnit: DateTimeUnit.msec,
        systemDateTime: systemTime, // Customize time precision
      );
      myAlarm?.start();
      debugPrint('Alarm triggered at $systemTime');
      myAlarm?.onAlarm.listen((dateTime) {
        if (dateTime != null) {
          debugPrint('Alarm triggered at $dateTime');
          DateTimeToast().show(message: 'Now is $dateTime');
        } else {
          debugPrint('Alarm stopped');
        }
      });
      Future.delayed(const Duration(seconds: 20), () {
        myAlarm?.stop();
      });
    }
    return Scaffold(
      body: homeWidget(context),
      floatingActionButton: null,
    );
  }

  Widget homeWidget(BuildContext context) {
    final num z = 12.asMonths();
    final DateTime utc = makeUtc(DateTime.now().addToMonth(z));
    final DateTimeAlarm g = DateTimeAlarm(
      alarmDateTime: utc,
      truncatedTimeUnit: DateTimeUnit.month,
    );
    debugPrint(g.toString());
    final DateTimeInterval _ = DateTimeInterval(
      startEvent: DateTime(2023, 1, 15),
      endEvent: DateTime(2024, 1, 15),
      roundedTo: DateTimeUnit.month,
    );

    return BlocProvider(
      create: (context) => RepeatingTimerCubit(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Assets.images.elapser1024x1024.image(),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Toast will a peer in 7 seconds'),
            const SizedBox(height: 10),
            const FluffWidget(),
          ],
        ),
      ),
    );
  }
}

class FluffWidget extends StatelessWidget {
  const FluffWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepeatingTimerCubit, RepeatingTimerState>(
      builder: (context, state) {
        debugPrint('State: $state ${state.startDateTime}');
        if (state is RepeatingTimerInitial) {
          context.read<RepeatingTimerCubit>().start();
          return const Text('Timer not started');
        } else if (state is RepeatingTimerStarted) {
          return Text('Timer started at ${state.startDateTime}');
        } else if (state is RepeatingTimerInterval) {
          return Text('Timer interval at ${state.startDateTime}');
        } else if (state is RepeatingTimerOff) {
          return Text('Timer stopped at ${state.startDateTime}');
        } else {
          return Text('Unknown state: $state');
        }
      },
    );
  }
}
