import 'package:flutter/material.dart';

class ProductItemModel {
  final String productName;
  final int id;
  final double price;
  int quantity;
  final String customerName; // Người đặt
  final DateTime orderDate; // Ngày đặt

  ProductItemModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.customerName,
    required this.orderDate,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}

class QuanLyDonHangAdmin extends StatefulWidget {
  const QuanLyDonHangAdmin({super.key});

  @override
  State<QuanLyDonHangAdmin> createState() => _QuanLyDonHangAdminState();
}

class _QuanLyDonHangAdminState extends State<QuanLyDonHangAdmin> {
  List<ProductItemModel> choDuyet = [
    ProductItemModel(
      id: 1,
      productName: "Xoài",
      price: 15000,
      quantity: 2,
      customerName: "Nguyễn Văn A",
      orderDate: DateTime(2025, 6, 4),
    ),
    ProductItemModel(
      id: 2,
      productName: "Cam",
      price: 12000,
      quantity: 3,
      customerName: "Trần Thị B",
      orderDate: DateTime(2025, 6, 5),
    ),
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
                  title: Text('${item.productName} - ${item.customerName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngày đặt: ${item.orderDate.day}/${item.orderDate.month}/${item.orderDate.year}'),
                      Text('Số lượng: ${item.quantity}'),
                      Text('Đơn giá: ${item.price.toStringAsFixed(0)}đ'),
                      Text('Tổng tiền: ${item.totalPrice.toStringAsFixed(0)}đ'),
                    ],
                  ),
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
                          child: const Text("Xóa", style: TextStyle(color: Colors.red)),
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
            _buildAdminOrderList("Chờ duyệt", choDuyet,
                nextList: daDuyet, nextLabel: "Duyệt"),
            _buildAdminOrderList("Đã duyệt", daDuyet,
                nextList: dangGiao, nextLabel: "Giao hàng"),
            _buildAdminOrderList("Đang giao", dangGiao,
                nextList: daMua, nextLabel: "Hoàn tất"),
            _buildAdminOrderList("Đã mua", daMua),
            _buildAdminOrderList("Đơn đã hủy", donHangDaHuy, canDelete: true),
          ],
        ),
      ),
    );
  }
}
