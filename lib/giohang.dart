import 'package:apptraicay/thanhtoan.dart';
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

class Giohang extends StatefulWidget {
  const Giohang({super.key});

  @override
  _GiohangState createState() => _GiohangState();
}

class _GiohangState extends State<Giohang> {
  final TextEditingController tk_sp = TextEditingController();

  List<ProductItemModel> choThanhToan = [
    ProductItemModel(id: 1, productName: "Táo", price: 10000, quantity: 2),
    ProductItemModel(id: 2, productName: "Chuối", price: 8000, quantity: 3),
  ];
  List<ProductItemModel> choDuyet = [
    ProductItemModel(id: 3, productName: "Xoài", price: 15000, quantity: 1),
  ];
  List<ProductItemModel> daDuyet = [];
  List<ProductItemModel> dangGiao = [];
  List<ProductItemModel> daMua = [];

  void _removeProductFromCart(int index) {
    setState(() {
      choThanhToan.removeAt(index);
    });
  }

  void _updateProductQuantity(int index, int newQuantity) {
    setState(() {
      choThanhToan[index].quantity = newQuantity;
    });
  }

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
          title: const Text("Giỏ hàng"),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.orangeAccent,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Chờ thanh toán'),
              Tab(text: 'Chờ duyệt'),
              Tab(text: 'Đã duyệt'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã mua'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Tìm kiếm + giỏ hàng
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
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
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined,
                            color: Colors.lightGreen),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 0,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${choThanhToan.fold(0, (sum, item) => sum + item.quantity)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Chờ thanh toán
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: choThanhToan.length,
                          itemBuilder: (context, index) {
                            final product = choThanhToan[index];
                            final backgroundColor = index.isEven
                                ? Colors.tealAccent.shade100
                                : Colors.lightGreen.shade50;

                            return Dismissible(
                              key: Key(product.productName),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                _removeProductFromCart(index);
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16.0),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(product.productName),
                                  subtitle: Text(
                                      'Giá: ${product.price}đ x ${product.quantity}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (product.quantity > 1) {
                                            _updateProductQuantity(index,
                                                product.quantity - 1);
                                          }
                                        },
                                      ),
                                      Text('${product.quantity}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _updateProductQuantity(index,
                                              product.quantity + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Tổng cộng:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${choThanhToan.fold<double>(0.0, (sum, item) => sum + item.price * item.quantity)}đ',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text("Mua tiếp"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (choThanhToan.isNotEmpty) {
                                setState(() {
                                  choDuyet.addAll(choThanhToan);
                                  choThanhToan.clear();
                                });
                              Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ThanhToanScreen()),);
                              }
                            },
                            child: const Text("Thanh toán"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),

                  // Tab 2: Chờ duyệt (có nút hủy đơn)
                  _buildOrderStatusList("Chờ duyệt", choDuyet,
                      allowCancel: true),

                  // Tab 3: Đã duyệt
                  _buildOrderStatusList("Đã duyệt", daDuyet),

                  // Tab 4: Đang giao
                  _buildOrderStatusList("Đang giao", dangGiao),

                  // Tab 5: Đã mua
                  _buildOrderStatusList("Đã mua", daMua),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
