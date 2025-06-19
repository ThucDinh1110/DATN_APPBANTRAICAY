import 'package:flutter/material.dart';
import 'donhang.dart'; // nơi chứa ProductItemModel

class ChiTietDonHangScreen extends StatelessWidget {
  final String ngayDat;
  final double tongTien;
  final String diaChi; // thêm dòng này
  final List<ProductItemModel> sanPhams;

  const ChiTietDonHangScreen({
    super.key,
    required this.ngayDat,
    required this.tongTien,
    required this.diaChi, // thêm dòng này
    required this.sanPhams,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết đơn hàng"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text("Ngày đặt hàng"),
            subtitle: Text(ngayDat),
          ),
          ListTile(
            title: const Text("Tổng tiền"),
            subtitle: Text("${tongTien.toStringAsFixed(0)} đ"),
          ),
          ListTile(
            title: const Text("Địa chỉ giao hàng"),
            subtitle: Text(diaChi),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Danh sách sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sanPhams.length,
              itemBuilder: (context, index) {
                final item = sanPhams[index];
                return ListTile(
                  title: Text(item.productName),
                  subtitle: Text("Số lượng: ${item.quantity}"),
                  trailing: Text("${item.price.toStringAsFixed(0)} đ"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
