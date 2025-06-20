import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'ibm.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _diachiController = TextEditingController();
  final TextEditingController _chieucaoController = TextEditingController();
  final TextEditingController _cannangController = TextEditingController();
  String _gender = 'Nam';
  String _nhuCau = 'Duy trì';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      print('Chưa đăng nhập hoặc không có user_id');
      setState(() => _isLoading = false);
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
          _diachiController.text = (data['Diachi'] ?? '').toString();
          _chieucaoController.text = (data['Chieucao'] ?? '').toString();
          _cannangController.text = (data['Cannang'] ?? '').toString();
        _gender = ['Nam', 'Nữ', 'Khác'].contains(data['Gioitinh']) 
    ? data['Gioitinh'] 
    : 'Nam';

         _nhuCau = ['Tăng cân', 'Giảm cân', 'Duy trì'].contains(data['Nhucau']) 
    ? data['Nhucau'] 
    : 'Duy trì';

          _isLoading = false;
        });
      } else {
        print("Lỗi khi tải dữ liệu: ${response.body}");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Lỗi khi kết nối API: $e");
      setState(() => _isLoading = false);
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
          'diachi': _diachiController.text.trim(),
          'gioitinh': _gender,
          'chieucao': int.tryParse(_chieucaoController.text.trim()) ?? 0,
          'cannang': int.tryParse(_cannangController.text.trim()) ?? 0,
          'nhucau': _nhuCau,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lưu thông tin thành công'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        print('Lỗi khi cập nhật: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lưu không thành công'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lỗi kết nối đến server'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _buildGlassField(String label, TextEditingController controller,
      {bool isMultiline = false, String? suffixText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller,
                maxLines: isMultiline ? null : 1,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  suffixText: suffixText,
                  suffixStyle: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Hồ sơ cá nhân',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2575FC),
              Colors.grey,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
                child: Column(
                  children: [
                    // Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(Icons.person,
                              size: 60, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Form
                    _buildGlassField("Họ và tên", _nameController),
                    _buildGlassField("Số điện thoại", _phoneController),
                    _buildGlassField("Email", _emailController),
                    _buildGlassField("Địa chỉ", _diachiController),

                    // Chiều cao & cân nặng
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: ListTile(
                            title: const Text("Chiều cao & Cân nặng",
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                              "${_chieucaoController.text} cm, ${_cannangController.text} kg",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ibm(
                                    chieucao: _chieucaoController.text,
                                    cannang: _cannangController.text,
                                    onSave: (newChieucao, newCannang) {
                                      setState(() {
                                        _chieucaoController.text = newChieucao;
                                        _cannangController.text = newCannang;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Gender dropdown
                    _buildDropdownField('Giới tính', _gender,
                        ['Nam', 'Nữ', 'Khác'], (value) {
                      setState(() => _gender = value);
                    }),

                    // Nhu cầu dropdown
                    _buildDropdownField('Nhu cầu', _nhuCau,
                        ['Tăng cân', 'Giảm cân', 'Duy trì'], (value) {
                      setState(() => _nhuCau = value);
                    }),

                    const SizedBox(height: 30),

                    // Save Button
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: Colors.white.withOpacity(0.5)),
                          ),
                          child: ElevatedButton(
                            onPressed: updateUserProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text("LƯU THÔNG TIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items,
      Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String>(
                value: value,
                items: items.map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child:
                        Text(val, style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                dropdownColor: Colors.white70,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (newValue) => onChanged(newValue!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
