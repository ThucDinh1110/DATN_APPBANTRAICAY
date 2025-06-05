import 'package:apptraicay/caidat.dart';
import 'package:apptraicay/donhang.dart';
import 'package:apptraicay/giohang.dart';
import 'package:apptraicay/thongtincanhan.dart';
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
  int _currentIndex = 0;

  List<ProductItemModel> productsInCart = [
    ProductItemModel(id: 1, productName: "Táo", price: 10000, quantity: 2),
    ProductItemModel(id: 2, productName: "Chuối", price: 8000, quantity: 3),
    ProductItemModel(id: 3, productName: "Xoài", price: 15000, quantity: 1),
    ProductItemModel(id: 4, productName: "Mận", price: 12000, quantity: 4),
  ];

  final List<Widget> _tabs = [
    const HomeTabContent(),
    const ProfilePage(),
    const Donhang(),
    const CaiDatPage(),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: _currentIndex == 0
      ? null
      : Text(
          _currentIndex == 1
              ? 'Thông tin cá nhân'
              : _currentIndex == 2
                  ? 'Đơn hàng'
                  : 'Cài đặt',
          style: const TextStyle(color: Colors.white),
        ),
  automaticallyImplyLeading: false,
        actions: [
          if(_currentIndex == 0)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search, color: Colors.orange),
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
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Giohang()),
                  );
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
      backgroundColor: Colors.white,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Thông tin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}

class HomeTabContent extends StatelessWidget {
  const HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Trang chủ - Danh sách sản phẩm ở đây',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
