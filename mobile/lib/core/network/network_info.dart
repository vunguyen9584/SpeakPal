import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    final result = await connectionChecker.checkConnectivity();
    // In connectivity_plus 6.0+, checking for emptiness or explicitly checking not none.
    // However, the documentation says it returns a list. If the device is disconnected,
    // it contains ConnectivityResult.none.
    return !result.contains(ConnectivityResult.none);
  }
}
