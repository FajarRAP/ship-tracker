import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ship_tracker/features/tracker/controller/tracker_controller.dart';

class TrackerPage extends GetView<TrackerController> {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ship Tracker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            controller.loginUseCase('halo', 'lorem');
          },
          child: const Text('Test'),
        ),
      ),
    );
  }
}
