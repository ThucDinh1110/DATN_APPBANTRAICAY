import 'package:apptraicay/diachigia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'giohang_service.dart';

class ProductItemModel {
  final String productName;
  final int id;
  final double price;
  int quantity;
  bool isSelected;

  ProductItemModel({
    required this.id,
    required this.productName,
    required this.price,
    this.quantity = 1,
    this.isSelected = false,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json['SanphamID'] ?? DateTime.now().millisecondsSinceEpoch,
      productName: json['ten_sanpham'] ?? '',
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
  int? userId;
  bool selectAll = false;
  Set<int> _processingProducts = {}; // để chặn spam nút

  @override
  void initState() {
    super.initState();
    loadUserIdAndCart();
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      for (var item in choThanhToan) {
        item.isSelected = selectAll;
      }
    });
  }

  Future<void> loadUserIdAndCart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getInt('user_id');

    if (savedId == null) {
      print("Không tìm thấy user_id");
      return;
    }

    setState(() {
      userId = savedId;
    });

    await fetchCart();
  }

  Future<void> fetchCart() async {
    if (userId == null) return;

    final url = Uri.parse('http://127.0.0.1:8000/api/getCart');

    try {
      final response = await http.post(url, body: {
        'user_id': userId.toString(),
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'];

        setState(() {
          choThanhToan =
              items.map((json) => ProductItemModel.fromJson(json)).toList();
        });
      } else {
        print('Lỗi lấy giỏ hàng: ${response.body}');
      }
    } catch (e) {
      print('Lỗi kết nối tới server: $e');
    }
  }

  Future<void> _removeProductFromCart(int index) async {
    final product = choThanhToan[index];
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập')),
      );
      return;
    }

    final success = await GioHangService.themVaoGioHang(
      userId: userId,
      productId: product.id,
      soluong: -product.quantity,
    );

    if (success) {
      setState(() {
        choThanhToan.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa sản phẩm khỏi giỏ hàng')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Xóa sản phẩm thất bại'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
  preferredSize: const Size.fromHeight(60),
  child: ClipRRect(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
    child: AppBar(
      backgroundColor: const Color.fromRGBO(95, 179, 249, 1),
      title: const Text(
        "Giỏ hàng",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      elevation: 0, // không bóng
    ),
  ),
),
      body: Column(
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
                        key: Key('${product.id}-${product.productName}'),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xác nhận xóa sản phẩm'),
                              content:
                                  Text('Bạn có muốn xóa "${product.productName}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Xóa',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          return confirm == true;
                        },
                        onDismissed: (_) => _removeProductFromCart(index),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child:
                              const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: product.isSelected,
                              onChanged: (value) {
                                setState(() {
                                  product.isSelected = value ?? false;
                                  selectAll = choThanhToan
                                      .every((e) => e.isSelected);
                                });
                              },
                            ),
                            title: Text(product.productName),
                            subtitle: Text(
                                'Giá: ${product.price}đ x ${product.quantity}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: _processingProducts.contains(product.id)
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : const Icon(Icons.remove),
                                  onPressed: _processingProducts
                                          .contains(product.id)
                                      ? null
                                      : () async {
                                          setState(() {
                                            _processingProducts
                                                .add(product.id);
                                          });

                                          if (product.quantity > 1) {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final userId = prefs.getInt(
                                                'user_id');

                                            final success =
                                                await GioHangService
                                                    .themVaoGioHang(
                                              userId: userId!,
                                              productId: product.id,
                                              soluong: -1,
                                            );

                                            if (success) {
                                              setState(() {
                                                product.quantity--;
                                              });
                                            }
                                          } else {
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                title:
                                                    const Text('Xác nhận xóa'),
                                                content: const Text(
                                                    'Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    child: const Text('Hủy'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    child: const Text('Xóa',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red)),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              await _removeProductFromCart(
                                                  index);
                                            }
                                          }

                                          setState(() {
                                            _processingProducts
                                                .remove(product.id);
                                          });
                                        },
                                ),
                                Text('${product.quantity}'),
                                IconButton(
                                  icon: _processingProducts.contains(product.id)
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : const Icon(Icons.add),
                                  onPressed: _processingProducts
                                          .contains(product.id)
                                      ? null
                                      : () async {
                                          setState(() {
                                            _processingProducts
                                                .add(product.id);
                                          });

                                          final prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          final userId =
                                              prefs.getInt('user_id');

                                          final success = await GioHangService
                                              .themVaoGioHang(
                                            userId: userId!,
                                            productId: product.id,
                                            soluong: 1,
                                          );

                                          if (success) {
                                            setState(() {
                                              product.quantity++;
                                            });
                                          }

                                          setState(() {
                                            _processingProducts
                                                .remove(product.id);
                                          });
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: selectAll, onChanged: toggleSelectAll),
                    const Text('Chọn tất cả',
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
                Text(
                  '${choThanhToan.where((e) => e.isSelected).fold<double>(0, (sum, item) => sum + item.price * item.quantity)}đ',
                  style:
                      const TextStyle(fontSize: 18, color: Colors.redAccent),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Mua tiếp"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final selected = choThanhToan
                          .where((e) => e.isSelected)
                          .toList();
                      if (selected.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Vui lòng chọn ít nhất 1 sản phẩm để thanh toán')),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiaChiGiaoHangScreen(
                              itemsToBuy: selected),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text("Thanh toán"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
