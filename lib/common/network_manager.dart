import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  NetworkManager._privateConstructor();

  static final NetworkManager _instance = NetworkManager._privateConstructor();

  static NetworkManager get instance => _instance;

  Connectivity connectivity = Connectivity();
  StreamSubscription? _subscription;

//streaming network connection every time
  initialiseNetworkManager() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    _subscription = connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  Future<bool> isConnected() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    return await _checkStatus(result);
  }

  Future<bool> _checkStatus(ConnectivityResult result) async {
    bool? isInternet = false;
    switch (result) {
      case ConnectivityResult.wifi:
        isInternet = true;
        break;
      case ConnectivityResult.mobile:
        isInternet = true;
        break;
      case ConnectivityResult.none:
        isInternet = false;
        break;
      default:
        isInternet = false;
        break;
    }
    if (isInternet) {
      isInternet = await _updateConnectionStatus();
    }

    return isInternet;
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected = true;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  dispose() {
    _subscription?.cancel();
  }
}
