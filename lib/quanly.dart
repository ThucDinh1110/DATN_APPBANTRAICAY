import 'package:apptraicay/qlssanpham.dart';
import 'package:flutter/material.dart';

class HomeManagementPage extends StatefulWidget {
  const HomeManagementPage({super.key});

  @override
  State<HomeManagementPage> createState() => _HomeManagementPageState();
}

class _HomeManagementPageState extends State<HomeManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý bán trái cây"),
        backgroundColor: const Color(0xFF2E7D32), // xanh lá đậm tươi
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildMenuButton(
              icon: Icons.people,
              label: "Quản lý khách hàng",
              color: const Color(0xFF43A047), // xanh lá tươi sáng
              onTap: () {
                print("Quản lý khách hàng");
              },
            ),
            _buildMenuButton(
              icon: Icons.warehouse,
              label: "Quản lý kho",
              color: const Color(0xFFFFEB3B), // vàng chanh rực rỡ
              onTap: () {
                print("Quản lý kho");
              },
            ),
            _buildMenuButton(
              icon: Icons.shopping_basket,
              label: "Quản lý sản phẩm",
              color: const Color(0xFFFF7043), // cam sáng nóng
              onTap: () {
                print("Quản lý sản phẩm");
              },
            ),
            _buildMenuButton(
              icon: Icons.receipt_long,
              label: "Quản lý đơn hàng",
              color: const Color(0xFF26A69A), // xanh biển đậm tươi
              onTap: () {
                
                print("Quản lý đơn hàng");
                 Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuanLyDonHangAdmin(),
                            ),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.75), // trong suốt hơi giảm chút để vẫn tươi
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.45),
              offset: const Offset(0, 5),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 15),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(
                    color: Colors.black38,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
