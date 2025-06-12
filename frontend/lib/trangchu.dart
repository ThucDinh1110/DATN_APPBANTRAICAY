import 'dart:convert';

import 'package:apptraicay/caidat.dart';
import 'package:apptraicay/donhang.dart';
import 'package:apptraicay/giohang.dart';
import 'package:apptraicay/thongtincanhan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController tk_sp = TextEditingController();
  int _currentIndex = 0;
  int _cartItemCount = 0;

  final List<Widget> _tabs = [
    const HomeTabContent(),
    const ProfilePage(),
    const Donhang(),
    const CaiDatPage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchCartItemCount();
  }

  Future<void> fetchCartItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/countCartItems?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _cartItemCount = data['count'] ?? 0;
        });
      }
    } catch (e) {
      print("Lỗi lấy số lượng sản phẩm giỏ hàng: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        automaticallyImplyLeading: false,
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
        actions: [
          if (_currentIndex == 0)
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
                  ).then((_) {
                    fetchCartItemCount(); // cập nhật lại khi quay về
                  });
                },
              ),
              if (_cartItemCount > 0)
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
                      '$_cartItemCount',
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
    return const Center(
      child: Text(
        'Trang chủ - Danh sách sản phẩm ở đây',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
