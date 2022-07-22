import 'package:flutter/services.dart';

class PlatformChannel {
  static const _channel = EventChannel("com.example.app/smsStream");

  Stream callStream() async* {
    yield* _channel.receiveBroadcastStream();
  }
}
