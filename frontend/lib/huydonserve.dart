import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'donhang.dart';

class HuyDonService {
  static Future<String> huyDonHang(int donhangId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      if (userId == null) return 'Không tìm thấy user';

      final url = Uri.parse('http://127.0.0.1:8000/api/huyDonHang');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'donhang_id': donhangId,
        }),
      );

      final data = jsonDecode(response.body);
      return data['message'] ?? 'Không có phản hồi từ server';
    } catch (e) {
      return 'Lỗi khi hủy đơn: $e';
    }
  }
}

