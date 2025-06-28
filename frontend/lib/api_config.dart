import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    }

    if (Platform.isAndroid) {
      return "http://192.168.1.61:8000"; // Đổi IP này thành IP máy bạn
    }

    if (Platform.isIOS) {
      return "http://localhost:8000";
    }

    return "http://localhost:8000";
  }
}
