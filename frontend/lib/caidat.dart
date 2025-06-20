import 'package:apptraicay/danhsachdiachi.dart';
import 'package:flutter/material.dart';
import 'package:apptraicay/doimatkhau.dart';
import 'package:apptraicay/dangnhap.dart';
import 'package:apptraicay/matkhaumoi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaiDatPage extends StatelessWidget {
  const CaiDatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.orange),
            title: const Text("Đổi mật khẩu"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordPage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_city, color: Colors.orange),
            title: const Text("Danh sách địa chỉ"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getInt('user_id');

              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DanhSachDiaChiScreen(userId: userId), // mặc định isSelectMode: false
                  ),
                );
              }
            },
          ),
          const Divider(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Xóa token/session nếu cần
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Đăng xuất"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
