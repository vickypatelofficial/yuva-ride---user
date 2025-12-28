import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/socket_services.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class CustomerHomeSocketProvider extends ChangeNotifier {
  final SocketService _socket = SocketService();

  bool isConnected = false;

  /// INIT SOCKET FOR CUSTOMER
  Future<void> init({
    required String rideId,
    required String driverId,
    required double customerLat,
    required double customerLon,
  }) async {
    final customerId = await LocalStorage.getUserId() ?? '';

    // 1️⃣ CONNECT SOCKET
    _socket.connect(
      socketUrl: AppUrl.socketUrl,
      query: {"userId": customerId},
    );

    // 2️⃣ JOIN CUSTOMER ROOM (MANDATORY)
    _socket.emit('join_customer_room', {
      "customer_id": customerId,
    });

    // 3️⃣ DRIVER ACCEPTED RIDE
    _socket.on('acceptvehrequest$customerId', (data) {
      debugPrint("🚗 Driver accepted ride");
      notifyListeners();
    });

    // 4️⃣ START LIVE TRACKING
    _socket.emit('start_ride_tracking', {
      "customer_id": customerId,
      "driver_id": driverId,
      "ride_id": rideId,
      "customer_lat": customerLat,
      "customer_lon": customerLon,
    });

    // 5️⃣ TRACKING START CONFIRMATION
    _socket.on('tracking_started', (data) {
      debugPrint("📍 Tracking started");
      debugPrint(data.toString());
      notifyListeners();
    });

    // 6️⃣ LIVE DRIVER LOCATION UPDATES
    _socket.on('driver_location_update', (data) {
      /*
        data contains:
        - driver_location
        - distance
        - eta
      */
      debugPrint("📡 Driver location update");
      notifyListeners();
    });

    // 7️⃣ DRIVER ARRIVED
    _socket.on('driver_nearby', (data) {
      debugPrint("✅ Driver has arrived");
      notifyListeners();
    });

    // 8️⃣ RIDE START / END
    _socket.on('Vehicle_Ride_Start_End$customerId', (data) {
      debugPrint("🏁 Ride status changed");
      notifyListeners();
    });

    // 9️⃣ RIDE CANCEL
    _socket.on('Vehicle_Ride_Cancel', (data) {
      debugPrint("❌ Ride cancelled");
      notifyListeners();
    });

    // 🔟 PAYMENT SCREEN
    _socket.on('Vehicle_Ride_Payment$customerId', (data) {
      debugPrint("💰 Payment required");
      notifyListeners();
    });

    // 1️⃣1️⃣ RIDE COMPLETE
    _socket.on('Vehicle_Ride_Complete$customerId', (data) {
      debugPrint("🎉 Ride completed");
      stopTracking(rideId);
      notifyListeners();
    });

    // 1️⃣2️⃣ CHAT RECEIVE
    _socket.on('New_Chat$customerId', (data) {
      debugPrint("💬 New chat message");
      notifyListeners();
    });

    isConnected = true;
    notifyListeners();
  }

  /// STOP TRACKING (ON RIDE END / CANCEL)
  void stopTracking(String rideId) {
    _socket.emit('stop_ride_tracking', {
      "ride_id": rideId,
    });
  }

  /// SEND CHAT MESSAGE
  void sendChat({
    required String customerId,
    required String driverId,
    required String message,
  }) {
    _socket.emit('Send_Chat', {
      "sender_id": customerId,
      "recevier_id": driverId,
      "message": message,
      "status": 1,
    });
  }

  /// CLEANUP
  void disposeSocket() {
    _socket.disconnect();
    isConnected = false;
    notifyListeners();
  }
}
