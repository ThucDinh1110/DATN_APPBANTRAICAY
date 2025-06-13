import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'sanpham.dart';

class SanPhamService {
  static Future<List<SanPham>> fetchSanPhams() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      throw Exception('Bạn chưa đăng nhập.');
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/sanpham'); // Đổi IP nếu cần

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SanPham.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi máy chủ: ${response.statusCode}');
    }
  }
}
