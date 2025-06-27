import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'api_config.dart';
class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _image;
  bool _isUploading = false;
  List<Map<String, dynamic>> _images = [];
  final String host = '${ApiConfig.baseUrl}';

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _chonAnh() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png', 'webp'])],
    );
    if (file != null) {
      setState(() {
        _image = File(file.path);
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
        await response.stream.bytesToString();
        _loadImages();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Tải ảnh thành công'),
          backgroundColor:Colors.deepPurple,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lỗi tải ảnh: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi: $e'),
        backgroundColor: Colors.red,
      ));
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
              'name': path.basename(item['path']),
              'size': item['size'] ?? 0,
            }).toList();
        setState(() {
          _images = images;
        });
      }
    } catch (e) {
      print('Lỗi khi load ảnh: $e');
    }
  }

  Future<void> _xoaAnh(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xoá ảnh'),
        content: Text('Bạn chắc chắn muốn xoá ảnh này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Huỷ')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Xoá', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(Uri.parse('$host/api/images/$id'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Xoá ảnh thành công'),
          backgroundColor:Colors.deepPurple,
        ));
        _loadImages();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lỗi xoá ảnh: ${response.statusCode}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý hình ảnh', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor:Colors.deepPurple[700],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Tải ảnh lên', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _image == null
                        ? Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('Chưa chọn ảnh', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_image!, height: 200, fit: BoxFit.cover),
                          ),
                    SizedBox(height: 16),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _chonAnh,
                                icon: Icon(Icons.image_search,color:Colors.white,),
                                label: Text('Chọn ảnh'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isUploading ? null : _uploadAnh,
                                icon: _isUploading
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : Icon(Icons.cloud_upload,color:Colors.white,),
                                label: Text(_isUploading ? 'Đang tải...' : 'Tải lên'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Ảnh đã tải lên', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _images.isEmpty
                ? Text('Chưa có ảnh nào được tải lên', style: TextStyle(color: Colors.grey))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final img = _images[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.network(
                                        img['url'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image, color: Colors.red)),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                        child: IconButton(
                                          icon: Icon(Icons.delete, color: Colors.white, size: 20),
                                          onPressed: () => _xoaAnh(img['id']),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                img['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
