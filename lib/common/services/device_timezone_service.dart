import 'package:flutter_timezone/flutter_timezone.dart';

class DeviceTimezoneService {
  DeviceTimezoneService._();

  static Future<String> getCurrentTimezone() async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    return timezone.identifier;
  }
}