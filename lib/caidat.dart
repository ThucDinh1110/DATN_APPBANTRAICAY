import 'package:flutter/material.dart';
import 'package:apptraicay/doimatkhau.dart'; // Đảm bảo đường dẫn đúng
import 'package:apptraicay/welcome.dart'; // Giả sử đăng xuất quay về màn hình Welcome

class CaiDatPage extends StatelessWidget {
  const CaiDatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.orange),
            title: const Text("Đổi mật khẩu"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const changepasswordPage()),
              );
            },
          ),
          const Divider(),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Xử lý đăng xuất tại đây (nếu cần xóa session/token)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
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
