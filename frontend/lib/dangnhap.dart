import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'dangky.dart';
import 'quanly.dart';
import 'quenmatkhau.dart';
import 'trangchu.dart';
import 'welcome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _matkhauController = TextEditingController();
  bool _anMatKhau = true;
  List<String> _savedPhones = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPhones();
  }

  Future<void> _loadSavedPhones() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPhones = prefs.getStringList('saved_phones') ?? [];
    });
  }

  Future<void> _savePhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_savedPhones.contains(phone)) {
      _savedPhones.insert(0, phone);
      if (_savedPhones.length > 5) {
        _savedPhones = _savedPhones.sublist(0, 5);
      }
      await prefs.setStringList('saved_phones', _savedPhones);
    }
  }

  Future<void> dangNhap() async {
    final sdt = _sdtController.text.trim();
    final matkhau = _matkhauController.text;

    if (sdt.isEmpty || matkhau.isEmpty) {
      _hienThongBao("Lỗi", "Vui lòng nhập đầy đủ thông tin.");
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': sdt, 'password': matkhau}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];
        final userId = user['UserID'];
        final role = user['Phanquyen'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);
        await prefs.setString('user_role', role);

        await _savePhone(sdt);

        if (role.toLowerCase() == 'admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeManagementPage()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        }
      } else {
        final data = jsonDecode(response.body);
        _hienThongBao("Đăng nhập thất bại", data['message'] ?? "Sai tài khoản hoặc mật khẩu");
      }
    } catch (e) {
      _hienThongBao("Lỗi kết nối", "Không thể kết nối đến server.");
    }
  }

  void _hienThongBao(String tieuDe, String noiDung) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tieuDe),
        content: Text(noiDung),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(95, 179, 249, 1),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const WelcomePage()));
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignupPage()));
              },
              child: const Text(
                "Đăng Ký",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Đăng Nhập",
                      style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Autocomplete số điện thoại
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return _savedPhones.where((phone) =>
                            phone.contains(textEditingValue.text));
                      },
                      onSelected: (String selection) {
                        _sdtController.text = selection;
                      },
                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Số Điện Thoại",
                            prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    TextField(
                      controller: _matkhauController,
                      obscureText: _anMatKhau,
                      decoration: InputDecoration(
                        labelText: "Mật Khẩu",
                        prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _anMatKhau ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _anMatKhau = !_anMatKhau;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: dangNhap,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromRGBO(95, 179, 249, 1),
                      ),
                      child: const Text(
                        "Đăng Nhập",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const forgotpasswordPage()),
                        );
                      },
                      child: const Text("Quên Mật Khẩu?"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
