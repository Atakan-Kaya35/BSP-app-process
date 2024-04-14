import 'package:flutter_test/flutter_test.dart';
import 'package:background/background.dart';
import 'package:background/background_platform_interface.dart';
import 'package:background/background_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBackgroundPlatform
    with MockPlatformInterfaceMixin
    implements BackgroundPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BackgroundPlatform initialPlatform = BackgroundPlatform.instance;

  test('$MethodChannelBackground is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBackground>());
  });

  test('getPlatformVersion', () async {
    Background backgroundPlugin = Background();
    MockBackgroundPlatform fakePlatform = MockBackgroundPlatform();
    BackgroundPlatform.instance = fakePlatform;

    expect(await backgroundPlugin.getPlatformVersion(), '42');
  });
}
