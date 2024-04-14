
import 'background_platform_interface.dart';

class Background {
  Future<String?> getPlatformVersion() {
    return BackgroundPlatform.instance.getPlatformVersion();
  }
}
