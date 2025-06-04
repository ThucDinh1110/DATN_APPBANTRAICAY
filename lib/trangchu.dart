import 'package:apptraicay/dangky.dart';
import 'package:apptraicay/doimatkhau.dart';
import 'package:apptraicay/donhang.dart';
import 'package:apptraicay/giohang.dart';
import 'package:apptraicay/quenmatkhau.dart';
import 'package:apptraicay/thongtincanhan.dart';
import 'package:apptraicay/welcome.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final TextEditingController tk_sp = TextEditingController();
  List<ProductItemModel> productsInCart = [
    ProductItemModel(id: 1, productName: "Táo", price: 10000, quantity: 2),
    ProductItemModel(id: 2, productName: "Chuối", price: 8000, quantity: 3),
    ProductItemModel(id: 3, productName: "Xoài", price: 15000, quantity: 1),
    ProductItemModel(id: 4, productName: "Mận", price: 12000, quantity: 4),
  ];

  void _removeProduct(int index) {
    setState(() {
      productsInCart.removeAt(index);
    });
  }

  void _updateProductQuantity(int index, int newQuantity) {
    setState(() {
      productsInCart[index].quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              elevation: 0,
              actions: [
                Padding(padding: const EdgeInsets.only(right: 16),
                child: 
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                        break;
                      case 'orders':
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Donhang()));
                        break;
                      case 'change password':
                        Navigator.push(context, MaterialPageRoute(builder: (_) => changepasswordPage()));
                        break;
                      case 'logout':
                        // Thực hiện đăng xuất
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (_) => const WelcomePage()),
                            (Route<dynamic> route) => false,
                            );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'profile',
                      child: Text('Thông tin cá nhân'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'orders',
                      child: Text('Đơn hàng'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'change password',
                      child: Text('Đổi mật khẩu'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Đăng xuất'),
                    ),
                  ],
                ),
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  // Tìm kiếm + giỏ hàng
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Icon(Icons.search,
                                    color: Colors.lightGreen),
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
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
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Giohang()));
                            },
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
                            '${productsInCart.fold(0, (sum, item) => sum + item.quantity)}',
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
                ]))));
  }
}
