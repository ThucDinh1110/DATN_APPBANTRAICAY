import 'package:apptraicay/diachigia.dart';
import 'package:flutter/material.dart';
import 'package:apptraicay/thanhtoan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: 0, // Có thể sửa nếu backend trả về ID
      productName: json['ten_sanpham'],
      price: double.tryParse(json['Gia'].toString()) ?? 0.0,
      quantity: json['Soluong'] ?? 1,
    );
  }
}

class Giohang extends StatefulWidget {
  const Giohang({super.key});

  @override
  _GiohangState createState() => _GiohangState();
}

class _GiohangState extends State<Giohang> {
  List<ProductItemModel> choThanhToan = [];
  int userId = 1; // Đổi theo user hiện tại

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/get-cart'); // 10.0.2.2 = localhost cho emulator

    try {
      final response = await http.post(url, body: {
        'user_id': userId.toString(),
      }, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'];

        setState(() {
          choThanhToan = items.map((json) => ProductItemModel.fromJson(json)).toList();
        });
      } else {
        print('Lỗi lấy giỏ hàng: ${response.body}');
      }
    } catch (e) {
      print('Lỗi kết nối tới server: $e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Giỏ hàng", style: TextStyle(color: Colors.green)),
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: choThanhToan.isEmpty
                      ? const Center(child: Text("Giỏ hàng trống"))
                      : ListView.builder(
                          itemCount: choThanhToan.length,
                          itemBuilder: (context, index) {
                            final product = choThanhToan[index];
                            final backgroundColor = index.isEven
                                ? Colors.green.shade50
                                : Colors.orange.shade50;

                            return Dismissible(
                              key: Key(product.productName),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                _removeProductFromCart(index);
                              },
                              background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16.0),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(product.productName),
                                  subtitle: Text('Giá: ${product.price}đ x ${product.quantity}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (product.quantity > 1) {
                                            _updateProductQuantity(index, product.quantity - 1);
                                          }
                                        },
                                      ),
                                      Text('${product.quantity}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _updateProductQuantity(index, product.quantity + 1);
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng cộng:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${choThanhToan.fold<double>(0.0, (sum, item) => sum + item.price * item.quantity)}đ',
                        style: const TextStyle(fontSize: 18, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Mua tiếp
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text("Mua tiếp"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DiaChiGiaoHangScreen()),
                            );
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text("Thanh toán"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
