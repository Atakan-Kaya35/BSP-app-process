import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'background_platform_interface.dart';

/// An implementation of [BackgroundPlatform] that uses method channels.
class MethodChannelBackground extends BackgroundPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('background');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
