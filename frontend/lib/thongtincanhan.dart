import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _chieucaoController = TextEditingController();
  final TextEditingController _cannangController = TextEditingController();
  String _gender = 'Nam';

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      print('Chưa đăng nhập hoặc không có user_id');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/getUserProfile?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['Hoten'] ?? '';
          _phoneController.text = data['Sodienthoai'] ?? '';
          _emailController.text = data['Email'] ?? '';
          _chieucaoController.text = (data['Chieucao'] ?? '').toString();
          _cannangController.text = (data['Cannang'] ?? '').toString();
          _gender = data['Gioitinh'] ?? 'Nam';
        });
      } else {
        print("Lỗi khi tải dữ liệu: ${response.body}");
      }
    } catch (e) {
      print("Lỗi khi kết nối API: $e");
    }
  }

  Future<void> updateUserProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');

  if (userId == null) {
    print("Chưa có user_id");
    return;
  }

  final url = Uri.parse('http://127.0.0.1:8000/api/updateUserProfile');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'hoten': _nameController.text.trim(),
        'sodienthoai': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'gioitinh': _gender, // đã là dạng chữ "Nam", "Nữ", "Khác"
        'chieucao': int.tryParse(_chieucaoController.text.trim()) ?? 0,
        'cannang': int.tryParse(_cannangController.text.trim()) ?? 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['message']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu thông tin thành công')),
      );
    } else {
      print('Lỗi khi cập nhật: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu không thành công')),
      );
    }
  } catch (e) {
    print("Lỗi kết nối: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lỗi kết nối đến server')),
    );
  }
}

  Widget _buildField(String label, TextEditingController controller,
      {bool isMultiline = false, String? suffixText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: isMultiline ? null : 1,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixText: suffixText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField("Họ và tên", _nameController),
            _buildField("Số điện thoại", _phoneController),
            _buildField("Email", _emailController),
            _buildField("Chiều cao", _chieucaoController, suffixText: "cm"),
            _buildField("Cân nặng", _cannangController, suffixText: "kg"),

            // Giới tính
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButtonFormField<String>(
                value:
                    ['Nam', 'Nữ', 'Khác'].contains(_gender) ? _gender : 'Nam',
                items: ['Nam', 'Nữ', 'Khác'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Thêm logic lưu lại thông tin
                updateUserProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Lưu thông tin"),
            ),
          ],
        ),
      ),
    );
  }
}
