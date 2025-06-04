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

class Donhang extends StatefulWidget {
  const Donhang({super.key});

  @override
  _DonhangState createState() => _DonhangState();
}

class _DonhangState extends State<Donhang> {
  final TextEditingController tk_sp = TextEditingController();

  // Dữ liệu mẫu cho từng trạng thái đơn hàng
  List<ProductItemModel> choDuyet = [
    ProductItemModel(id: 1, productName: "Xoài", price: 15000, quantity: 2),
    ProductItemModel(id: 2, productName: "Cam", price: 12000, quantity: 3),
    ProductItemModel(id: 3, productName: "Ổi", price: 10000, quantity: 1),
  ];

  List<ProductItemModel> daDuyet = [
    ProductItemModel(id: 4, productName: "Nho", price: 25000, quantity: 1),
    ProductItemModel(id: 5, productName: "Chuối", price: 8000, quantity: 5),
  ];

  List<ProductItemModel> dangGiao = [
    ProductItemModel(id: 6, productName: "Dưa hấu", price: 20000, quantity: 1),
    ProductItemModel(id: 7, productName: "Táo Mỹ", price: 30000, quantity: 2),
  ];

  List<ProductItemModel> daMua = [
    ProductItemModel(id: 8, productName: "Bưởi", price: 18000, quantity: 2),
    ProductItemModel(id: 9, productName: "Lê Hàn Quốc", price: 35000, quantity: 1),
  ];

  List<ProductItemModel> donHangDaHuy = [
    ProductItemModel(id: 10, productName: "Mận", price: 10000, quantity: 3),
    ProductItemModel(id: 11, productName: "Vú sữa", price: 22000, quantity: 1),
  ];

  Widget _buildOrderStatusList(String title, List<ProductItemModel> items,
      {bool allowCancel = false}) {
    return items.isEmpty
        ? Center(child: Text("Không có đơn nào trong mục '$title'"))
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.orange),
                  title: Text(item.productName),
                  subtitle:
                      Text('Số lượng: ${item.quantity} | Giá: ${item.price}đ'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (allowCancel)
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Hủy đơn hàng"),
                                content: const Text(
                                    "Bạn có chắc muốn hủy đơn này không?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("Không"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        // Di chuyển đơn hàng sang danh sách đã hủy
                                        donHangDaHuy.add(item);
                                        items.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Hủy đơn",
                                        style:
                                            TextStyle(color: Colors.redAccent)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Hủy đơn",
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
          backgroundColor: Colors.white,
          title: const Text("Đơn hàng của bạn"),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.orangeAccent,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Chờ duyệt'),
              Tab(text: 'Đã duyệt'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã mua'),
              Tab(text: 'Đơn hàng đã hủy'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Tìm kiếm sản phẩm đơn giản (chỉ giao diện)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightGreen),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(Icons.search, color: Colors.lightGreen),
                    ),
                    Expanded(
                      child: TextField(
                        controller: tk_sp,
                        decoration: const InputDecoration(
                          hintText: 'Tìm sản phẩm',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Chờ duyệt (cho phép hủy đơn)
                  _buildOrderStatusList("Chờ duyệt", choDuyet,
                      allowCancel: true),

                  // Tab 2: Đã duyệt
                  _buildOrderStatusList("Đã duyệt", daDuyet),

                  // Tab 3: Đang giao
                  _buildOrderStatusList("Đang giao", dangGiao),

                  // Tab 4: Đã mua
                  _buildOrderStatusList("Đã mua", daMua),

                  // Tab 5: Đơn hàng đã hủy
                  _buildOrderStatusList("Đơn hàng đã hủy", donHangDaHuy),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
