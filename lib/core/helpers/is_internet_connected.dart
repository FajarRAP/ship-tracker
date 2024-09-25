import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isInternetConnected() async {
  final connectivity = await Connectivity().checkConnectivity();
  return !connectivity.contains(ConnectivityResult.none);
}
