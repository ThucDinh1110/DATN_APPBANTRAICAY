import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'caidat.dart';
import 'donhang.dart';
import 'giohang.dart';
import 'thongtincanhan.dart';
import 'HomeTabContent .dart'; // ✅ bỏ khoảng trắng giữa tên file

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _cartItemCount = 0;
  String _searchKeyword = '';

  final TextEditingController tk_sp = TextEditingController();

  List<Widget> get _tabs => [
        HomeTabContent(keyword: _searchKeyword), // ✅ truyền keyword
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
        Uri.parse('http://127.0.0.1:8000/api/countCartItems?user_id=$userId'),
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
                        onChanged: (value) {
                          setState(() {
                            _searchKeyword = value; // ✅ cập nhật từ khóa
                          });
                        },
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
                  ).then((_) => fetchCartItemCount());
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
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Thông tin'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Đơn hàng'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}
