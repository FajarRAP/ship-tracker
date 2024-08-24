import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ship_tracker/features/tracker/controller/tracker_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
          onPressed: () async {
            // controller.login('fajary781@gmail.com', 'password');
            // controller.register('fajary781@gmail.com', 'password');
            // print(await Supabase.instance.client
            //     .from('ships')
            //     .insert({'receipt_number': '191102', 'stage_id': 2}));
            // final datas =
            // await Supabase.instance.client.from('stages').select();
            // print(datas.map((e) => '${e['name']}'));
            controller.logout();
          },
          child: const Text('LOGOUT'),
        ),
      ),
    );
  }
}
