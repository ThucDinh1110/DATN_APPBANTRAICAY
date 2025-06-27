import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
class DanhmucService {
  static Future<List<Map<String, dynamic>>> fetchDanhmucs() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/danhmucs');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<Map<String, dynamic>>((e) => {
        'DanhmucID': e['DanhmucID'],
        'Tendanhmuc': e['Tendanhmuc'],
      }).toList();
    } else {
      throw Exception('Lỗi khi lấy danh mục: ${response.statusCode}');
    }
  }
}
