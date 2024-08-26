import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/constants.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ship Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push(scanReceiptRoute),
              child: const Text('Scan'),
            ),
            ElevatedButton(
              onPressed: () => context.push(checkReceiptRoute),
              child: const Text('Check'),
            ),
            ElevatedButton(
              onPressed: () => context.push(packReceiptRoute),
              child: const Text('Pack'),
            ),
            ElevatedButton(
              onPressed: () => context.push(sendReceiptRoute),
              child: const Text('Send'),
            ),
            ElevatedButton(
              onPressed: () => context.push(reportRoute),
              child: const Text('Report'),
            ),
          ],
        ),
      ),
    );
  }
}
