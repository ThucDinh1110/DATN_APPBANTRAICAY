import 'package:flutter/material.dart';
import 'sanpham.dart'; // import class SanPham
import 'sanpham_service.dart'; // import service lấy dữ liệu
import 'chitietsanpham.dart'; // import màn hình chi tiết sản phẩm

void showGoiYTraiCayDialog(BuildContext context, String mucTieu) async {
  List<SanPham> danhSach = await SanPhamService.fetchSanPhams();

  List<SanPham> goiY = danhSach.where((sp) {
    switch (mucTieu) {
      case 'Tăng cân':
        return (sp.duong ?? 0) > 10 && (sp.tinhbot ?? 0) > 10;
      case 'Giảm cân':
        return (sp.chatxo ?? 0) > 2 && (sp.duong ?? 0) < 10 && (sp.tinhbot ?? 0) < 15;
      case 'Duy trì':
        return (sp.vitamina ?? 0) > 20 && (sp.vitaminc ?? 0) > 20;
      default:
        return false;
    }
  }).toList();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Trái cây gợi ý cho $mucTieu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        content: SizedBox(
          height: 240,
          width: double.maxFinite,
          child: goiY.isEmpty
              ? const Center(child: Text("Không có trái cây phù hợp."))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: goiY.length,
                  itemBuilder: (context, index) {
                    final sp = goiY[index];
                    return InkWell(
                      onTap: () {
                        // Đóng dialog trước khi chuyển sang màn hình chi tiết
                        Navigator.of(context).pop();
                        // Chuyển đến màn hình chi tiết sản phẩm
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>chitietsppage (sanPham: sp),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: Card(
                          color: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (sp.hinhanh != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/${sp.hinhanh}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  sp.ten,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${sp.gia.toInt()}đ / ${sp.donvi}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            child: Text(
              "Đóng",
              style: TextStyle(fontSize: 16, color: Colors.green[800]),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
      );
    },
  );
}