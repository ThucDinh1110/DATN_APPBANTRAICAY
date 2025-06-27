import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';
class EditAddressPage extends StatefulWidget {
  final int? diachiId;
  final String? name;
  final String? phone;
  final String? address;

  const EditAddressPage({
    super.key,
    this.diachiId,
    this.name,
    this.phone,
    this.address,
  });

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _addressController = TextEditingController(text: widget.address ?? '');
  }

  Future<void> _saveAddress() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  if (userId == null) return;

  final url = Uri.parse('${ApiConfig.baseUrl}/api/updateOrInsert');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': widget.diachiId,
        'user_id': userId,
        'hoten': _nameController.text.trim(),
        'sodienthoai': _phoneController.text.trim(),
        'diachi': _addressController.text.trim(),
      }),
    );

    print("RESPONSE CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cập nhật thất bại: ${response.body}")),
      );
    }
  } catch (e) {
    print("LỖI: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Lỗi kết nối: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diachiId == null ? 'Thêm địa chỉ' : 'Chỉnh sửa địa chỉ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Họ tên'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
              maxLines: 3,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: ()async{
                await _saveAddress();
                //Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Lưu địa chỉ'),
            ),
          ],
        ),
      ),
    );
  }
}
