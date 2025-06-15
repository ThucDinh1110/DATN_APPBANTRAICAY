import 'package:apptraicay/dangky.dart';
import 'package:apptraicay/dangnhap.dart';
import 'package:apptraicay/welcome.dart';
import 'package:flutter/material.dart';

class newpasswordPage extends StatefulWidget {
  const newpasswordPage({super.key});

  @override
  State<newpasswordPage> createState() => _newpasswordPageState();
}

class _newpasswordPageState extends State<newpasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(95, 179, 249, 1),
      body: Stack(
        children: [
          // Nút quay lại nằm ở ngoài nền trắng
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 6, 0, 0), size: 30),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ),

          // Phần khung trắng đăng nhập
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Mật Khẩu Mới",
                      style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      //controller: _matkhauController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu mới",
                        prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      //controller: _matkhauController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Nhập Lại",
                        prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Thành công'),
                            content: const Text('Mật khẩu mới đã được đặt thành công.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // đóng dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor:Color.fromRGBO(95, 179, 249, 1),
                         
                      foregroundColor: Colors.white,
                      ),
                      child: const Text("Cập Nhật"),
                    ),
                    const SizedBox(height: 16),
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
