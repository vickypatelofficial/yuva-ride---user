import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  // connect socket
  void connect({
    required String socketUrl,
    Map<String, dynamic>? query,
  }) {
    if (_socket != null && _socket!.connected) {
      return;
    }

    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery(query ?? {})
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ Socket connected');
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    _socket!.onConnectError((err) {
      print('⚠️ Socket connect error: $err');
    });
  }

  void joinDriverRoom(String driverId) {
    final room = "driver_$driverId";
    print("🔗 Joining room: $room");
    _socket?.emit("join", room);
  }

  void joinCustomerRoom(String customerId) {
    final room = "customer_$customerId";
    print("🔗 Joining room: $room");
    _socket?.emit("join", room);
  }

  // listen event
  void on(String event, Function(dynamic data) callback) {
    print("🎧 LISTEN CALLED for event → $event");
    _socket?.off(event);
    _socket?.on(event, (data) {
      print("📥 EVENT HIT → $event");
      print("📦 DATA → $data");
      callback(data);
    });
  }

  // emit event
  void emit(String event, dynamic data) {
    print('emit data');
    print(data.toString());
    if (_socket?.connected == true) {
      _socket?.emit(event, data);
    } else {
      print('⚠️ Socket not connected, emit skipped');
    }
  }

  // remove listener
  void off(String event) {
    _socket?.off(event);
  }

  // disconnect socket
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }
}
