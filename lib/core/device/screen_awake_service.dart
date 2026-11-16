import 'package:wakelock_plus/wakelock_plus.dart';

class ScreenAwakeService {
  Future<void> enable() async {
    await WakelockPlus.enable();
  }

  Future<void> disable() async {
    await WakelockPlus.disable();
  }

  Future<bool> get isEnabled async {
    return await WakelockPlus.enabled;
  }
}