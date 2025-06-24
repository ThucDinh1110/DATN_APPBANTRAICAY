import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:convert';

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _image;
  bool _isUploading = false;
  String? _uploadedImageUrl;
  List<Map<String, dynamic>> _images = [];

  final String host = 'http://127.0.0.1:8000'; // Dành cho desktop

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _chonAnh() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png'])],
    );
    if (file != null) {
      setState(() {
        _image = File(file.path);
        _uploadedImageUrl = null;
      });
    }
  }

  Future<void> _uploadAnh() async {
    if (_image == null) return;
    setState(() => _isUploading = true);

    final uri = Uri.parse('$host/api/upload-image');
    final request = http.MultipartRequest('POST', uri);
    final mimeType = lookupMimeType(_image!.path)?.split('/');
    if (mimeType == null) return;

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      _image!.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    ));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);
        setState(() {
          _uploadedImageUrl = '$host/${data['image']['path']}';
        });
        _loadImages();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Tải ảnh thành công')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Lỗi tải ảnh: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Lỗi: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _loadImages() async {
    try {
      final response = await http.get(Uri.parse('$host/api/images'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final images = data.map<Map<String, dynamic>>((item) => {
              'id': item['id'],
              'url': '$host/${item['path']}',
            }).toList();
        setState(() {
          _images = images;
        });
      }
    } catch (e) {
      print('❌ Lỗi khi load ảnh: $e');
    }
  }

  Future<void> _xoaAnh(int id) async {
    try {
      final response = await http.delete(Uri.parse('$host/api/images/$id'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🗑️ Đã xoá ảnh')));
        _loadImages();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Lỗi xoá ảnh: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tải ảnh lên từ máy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _chonAnh,
              icon: Icon(Icons.image),
              label: Text('Chọn ảnh'),
            ),
            SizedBox(height: 16),
            if (_image != null)
              Column(
                children: [
                  Image.file(_image!, height: 200),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _uploadAnh,
                    icon: Icon(Icons.cloud_upload),
                    label: _isUploading
                        ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text('Tải lên'),
                  ),
                ],
              ),
            if (_uploadedImageUrl != null)
              Column(
                children: [
                  SizedBox(height: 16),
                  Text('Ảnh vừa tải lên:'),
                  Image.network(_uploadedImageUrl!, height: 200),
                ],
              ),
            Divider(height: 32),
            Text('Danh sách ảnh đã upload:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            if (_images.isEmpty)
              Text('Chưa có ảnh nào')
            else
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final img = _images[index];
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          img['url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, color: Colors.red),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _xoaAnh(img['id']),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
