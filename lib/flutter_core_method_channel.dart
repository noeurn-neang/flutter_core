import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_core_platform_interface.dart';

/// An implementation of [FlutterCorePlatform] that uses method channels.
class MethodChannelFlutterCore extends FlutterCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_core');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
