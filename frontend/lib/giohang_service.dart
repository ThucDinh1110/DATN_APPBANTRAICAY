import 'package:http/http.dart' as http;
import 'dart:convert';

class GioHangService {
  static Future<bool> themVaoGioHang({
    required int userId,
    required int productId,
    required int soluong,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/them'); // thay bằng IP thật

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'product_id': productId,
        'soluong': soluong,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    } else {
      print("Lỗi: ${response.body}");
      return false;
    }
  }
  
}
