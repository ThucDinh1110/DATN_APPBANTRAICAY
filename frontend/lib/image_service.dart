import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'api_config.dart';
class ImageService {
  static final String baseUrl = ApiConfig.baseUrl;
 

  static Future<void> uploadImage(File imageFile) async {
    final uri = Uri.parse('$baseUrl/api/upload-image');
    final request = http.MultipartRequest('POST', uri);

    final mimeType = lookupMimeType(imageFile.path)?.split('/');
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType(mimeType![0], mimeType[1]),
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Tải ảnh thành công');
    } else {
      throw Exception('Lỗi tải ảnh: ${response.statusCode}');
    }
  }

  static Future<List<String>> fetchImages() async {
    final response = await http.get(Uri.parse('$baseUrl/api/images'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<String>((item) => '$baseUrl/' + item['path']).toList();
    } else {
      throw Exception('Lỗi tải danh sách ảnh');
    }
  }
}
