import 'package:flutter/material.dart';

class ProductItemModel {
  final String productName;
  final int id;
  final double price;
  int quantity;

  ProductItemModel({
    required this.id,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });
}

class QuanLyDonHangAdmin extends StatefulWidget {
  const QuanLyDonHangAdmin({super.key});

  @override
  State<QuanLyDonHangAdmin> createState() => _QuanLyDonHangAdminState();
}

class _QuanLyDonHangAdminState extends State<QuanLyDonHangAdmin> {
  List<ProductItemModel> choDuyet = [
    ProductItemModel(id: 1, productName: "Xoài", price: 15000, quantity: 2),
    ProductItemModel(id: 2, productName: "Cam", price: 12000, quantity: 3),
  ];

  List<ProductItemModel> daDuyet = [];
  List<ProductItemModel> dangGiao = [];
  List<ProductItemModel> daMua = [];
  List<ProductItemModel> donHangDaHuy = [];

  void chuyenTrangThai(
      ProductItemModel item, List<ProductItemModel> fromList, List<ProductItemModel> toList) {
    setState(() {
      fromList.remove(item);
      toList.add(item);
    });
  }

  Widget _buildAdminOrderList(String title, List<ProductItemModel> items,
      {List<ProductItemModel>? nextList,
      String? nextLabel,
      bool canDelete = false}) {
    return items.isEmpty
        ? Center(child: Text("Không có đơn nào trong mục '$title'"))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.blue),
                  title: Text(item.productName),
                  subtitle:
                      Text('Số lượng: ${item.quantity} | Giá: ${item.price}đ'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (nextList != null && nextLabel != null)
                        ElevatedButton(
                          onPressed: () => chuyenTrangThai(item, items, nextList),
                          child: Text(nextLabel),
                        ),
                      if (canDelete)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                          child: const Text("Xóa",
                              style: TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Quản lý đơn hàng (Admin)"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Chờ duyệt"),
              Tab(text: "Đã duyệt"),
              Tab(text: "Đang giao"),
              Tab(text: "Đã mua"),
              Tab(text: "Đã hủy"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Chờ duyệt -> Đã duyệt
            _buildAdminOrderList("Chờ duyệt", choDuyet,
                nextList: daDuyet, nextLabel: "Duyệt"),

            // Đã duyệt -> Đang giao
            _buildAdminOrderList("Đã duyệt", daDuyet,
                nextList: dangGiao, nextLabel: "Giao hàng"),

            // Đang giao -> Đã mua
            _buildAdminOrderList("Đang giao", dangGiao,
                nextList: daMua, nextLabel: "Hoàn tất"),

            // Đã mua (chỉ xem)
            _buildAdminOrderList("Đã mua", daMua),

            // Đơn hủy (có thể xóa)
            _buildAdminOrderList("Đơn đã hủy", donHangDaHuy, canDelete: true),
          ],
        ),
      ),
    );
  }
}
