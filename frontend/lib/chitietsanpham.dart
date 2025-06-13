import 'package:flutter/material.dart';
import 'sanpham.dart';

class chitietsppage extends StatelessWidget {
  final SanPham sanPham;

  const chitietsppage({super.key, required this.sanPham});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sanPham.ten),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(Icons.shopping_bag, size: 80, color: Colors.green),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tên sản phẩm:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(sanPham.ten),
                const SizedBox(height: 12),
                Text(
                  'Giá:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${sanPham.gia.toStringAsFixed(0)} đ'),
                const SizedBox(height: 12),
                Text(
                  'Đơn vị tính:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(sanPham.donvi),
                const SizedBox(height: 12),
                // Bạn có thể thêm nhiều thông tin hơn nếu có, ví dụ mô tả, vitamin,...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
