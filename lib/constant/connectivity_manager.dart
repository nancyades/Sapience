import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Function(ConnectivityResult)? onConnectivityChanged;

  ConnectivityManager({this.onConnectivityChanged}) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (onConnectivityChanged != null) {
        onConnectivityChanged!(result.first);
      }
    });
  }

  Future<bool> isConnected() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }


  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
