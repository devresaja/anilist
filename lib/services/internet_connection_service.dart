import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  static final InternetConnectionService _instance =
      InternetConnectionService._internal();

  factory InternetConnectionService() => _instance;

  InternetConnectionService._internal();

  static InternetConnectionService get instance => _instance;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _controller.stream;

  bool _isInitialized = false;

  void init() {
    if (_isInitialized) return;
    _isInitialized = true;

    InternetConnection().onStatusChange.listen((status) {
      _isConnected = status == InternetStatus.connected;
      _controller.add(_isConnected);
    });
  }
}
