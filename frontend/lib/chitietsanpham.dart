import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sanpham.dart';
import 'giohang_service.dart';
import 'api_config.dart';

class chitietsppage extends StatefulWidget {
  final SanPham sanPham;

  const chitietsppage({super.key, required this.sanPham});

  @override
  State<chitietsppage> createState() => _chitietsppageState();
}

class _chitietsppageState extends State<chitietsppage> {
  int quantity = 1;
  final String host = '${ApiConfig.baseUrl}'; // Laravel local API

  @override
  Widget build(BuildContext context) {
    final sanPham = widget.sanPham;
    final imageUrl = '$host/storage/images/${sanPham.hinhanh}';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white.withOpacity(0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sanPham.ten,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${sanPham.gia.toStringAsFixed(0)} VNĐ/${sanPham.donvi}',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (quantity > 1) setState(() => quantity--);
                                          },
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.remove, size: 16, color: Colors.black),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(quantity.toString(), style: const TextStyle(color: Colors.white, fontSize: 16)),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() => quantity++);
                                          },
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.black,
                                            child: Icon(Icons.add, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildNutritionRow(Icons.bolt, 'Vitamin A', '${sanPham.vitamina} μg'),
                              _buildNutritionRow(Icons.eco, 'Vitamin C', '${sanPham.vitaminc} mg'),
                              _buildNutritionRow(Icons.grass, 'Chất xơ', '${sanPham.chatxo} g'),
                              _buildNutritionRow(Icons.cake, 'Đường', '${sanPham.duong} g'),
                              _buildNutritionRow(Icons.rice_bowl, 'Tinh bột', '${sanPham.tinhbot} g'),
                              const SizedBox(height: 20),
                              Text(
                                sanPham.mota ?? 'Mô tả sản phẩm không có sẵn',
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[100],
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  ),
                                  onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    final userId = prefs.getInt('user_id');

                                    if (userId == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Vui lòng đăng nhập để thêm sản phẩm vào giỏ')),
                                      );
                                      return;
                                    }

                                    final success = await GioHangService.themVaoGioHang(
                                      userId: userId,
                                      productId: sanPham.id,
                                      soluong: quantity,
                                    );

                                    if (success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('🎉 Sản phẩm đã được thêm vào giỏ hàng'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      await Future.delayed(const Duration(milliseconds: 800));
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('❌ Thêm sản phẩm thất bại, vui lòng thử lại'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.shopping_cart_outlined, color: Colors.black),
                                      SizedBox(width: 8),
                                      Text("Thêm vào giỏ hàng", style: TextStyle(fontSize: 16, color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
