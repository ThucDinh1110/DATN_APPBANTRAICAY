import 'package:apptraicay/qlkhohang.dart';
import 'package:apptraicay/thongke.dart';
import 'package:flutter/material.dart';
import 'dangnhap.dart';
import 'qlkhachhang.dart';
import 'qlsanpham.dart';
import 'qlsdonhang.dart';
import 'image_gallery_page.dart';

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
        title:  Text("Quản lý bán trái cây",style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold),),
        backgroundColor: const Color(0xFF2E7D32),
        centerTitle: true,
        
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout,color: Colors.white,),
            tooltip: 'Đăng xuất',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildMenuButton(
                icon: Icons.people,
                label: "Quản lý khách hàng",
                color: const Color(0xFF43A047),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuanLyKhachHangAdmin()),
                  );
                },
              ),
              _buildMenuButton(
                icon: Icons.warehouse,
                label: "Quản lý kho",
                color: const Color(0xFFFFEB3B),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NhapHangTabPage()),
                  );
                },
              ),
               SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.image,color: Colors.white,),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Thống Kê',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>ThongKeDoanhThuPage ()),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 62, 31, 235),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                ),
              ),
              _buildMenuButton(
                icon: Icons.shopping_basket,
                label: "Quản lý sản phẩm",
                color: const Color(0xFFFF7043),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminSanPhamPage()),
                  );
                },
              ),
              _buildMenuButton(
                icon: Icons.receipt_long,
                label: "Quản lý đơn hàng",
                color: const Color(0xFF26A69A),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuanLyDonHangAdmin()),
                  );
                },
              ),
             
              // Nút chiếm 100% chiều ngang
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.image,color: Colors.white,),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Thư viện hình ảnh',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadImagePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                ),
              ),
            ],
          ),
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
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                offset: const Offset(0, 5),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
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
      ),
    );
  }
}
