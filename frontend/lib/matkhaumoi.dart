import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor:  Color.fromRGBO(95, 179, 249, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu hiện tại'),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu mới'),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Gửi API đổi mật khẩu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đổi mật khẩu thành công')),
                );
                Navigator.pop(context); // Quay lại màn hình cài đặt
              },
              child: const Text('Lưu'),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
