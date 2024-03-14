// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

import 'package:datetime_dart/datetime_dart.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeWidget(context),
      floatingActionButton: null,
    );
  }

  Widget homeWidget(BuildContext context) {
    //TODO: Replace with your own code
    // ignore: non_constant_identifier_names
    final PackageTemplate datetime_dart = PackageTemplate();
    debugPrint('$datetime_dart');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.images.ltmm1024x1024.image(),
            ),
          ),
        ],
      ),
    );
  }
}
