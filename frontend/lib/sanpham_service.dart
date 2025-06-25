import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'sanpham.dart';

class SanPhamService {
  // Dành cho người dùng đã đăng nhập (chỉ sản phẩm hoạt động)
  static Future<List<SanPham>> fetchSanPhams() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      throw Exception('Bạn chưa đăng nhập.');
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/sanpham');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SanPham.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi máy chủ: ${response.statusCode}');
    }
  }

  // Dành cho admin: lấy toàn bộ sản phẩm (cả đã ẩn)
  static Future<List<SanPham>> fetchAllSanPhams() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/sanpham/full');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SanPham.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi máy chủ: ${response.statusCode}');
    }
  }

  static Future<void> updateSanPham(int id, Map<String, dynamic> data) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/sanpham/$id');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode != 200) {
    throw Exception('Lỗi cập nhật sản phẩm: ${response.body}');
  }
}

}
