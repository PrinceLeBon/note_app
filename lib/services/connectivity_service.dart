import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  final Logger _logger = Logger();
  
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _wasOffline = false;
  bool _isInitialized = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;
    
    // Check initial status
    checkConnection();
    
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool isOnline = _isConnected(results);
      
      _logger.i("Connectivity changed: ${results.map((r) => r.name).join(', ')} - Online: $isOnline");
      
      // If we were offline and now online, trigger sync
      if (_wasOffline && isOnline) {
        _logger.i("🌐 Internet is back! Triggering automatic sync...");
        _connectionStatusController.add(true);
        _wasOffline = false;
      } else if (!isOnline && !_wasOffline) {
        _logger.i("📵 Internet disconnected");
        _wasOffline = true;
        _connectionStatusController.add(false);
      }
    });
  }
  
  bool _isConnected(List<ConnectivityResult> results) {
    return results.isNotEmpty && 
           !results.contains(ConnectivityResult.none) &&
           (results.contains(ConnectivityResult.wifi) ||
            results.contains(ConnectivityResult.mobile) ||
            results.contains(ConnectivityResult.ethernet));
  }
  
  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      bool isOnline = _isConnected(results);
      _wasOffline = !isOnline;
      _logger.i("Connection check: ${results.map((r) => r.name).join(', ')} - Online: $isOnline");
      return isOnline;
    } catch (e) {
      _logger.e("Error checking connectivity: $e");
      return false;
    }
  }
  
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
    _isInitialized = false;
  }
}
