import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'caidat.dart';
import 'donhang.dart';
import 'giohang.dart';
import 'thongtincanhan.dart';
import 'HomeTabContent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _cartItemCount = 0;
  String _searchKeyword = '';
  String _tenNguoiDung = 'Bạn'; // Tên người dùng sẽ hiển thị

  final TextEditingController tk_sp = TextEditingController();

  List<Widget> get _tabs => [
        HomeTabContent(keyword: _searchKeyword),
        const ProfilePage(),
        const Donhang(),
        const CaiDatPage(),
      ];

  @override
  void initState() {
    super.initState();
    fetchCartItemCount();
    fetchTenNguoiDung();
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

  Future<void> fetchTenNguoiDung() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/getUserProfile?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _tenNguoiDung = data['Hoten'] ?? 'Bạn';
        });
      }
    } catch (e) {
      print("Lỗi lấy tên người dùng: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(95, 179, 249, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(top: 25, left: 16, right: 16, bottom: 20),
            child: _currentIndex == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Chào mừng, $_tenNguoiDung',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: tk_sp,
                                decoration: const InputDecoration(
                                  hintText: 'Tìm sản phẩm...',
                                  hintStyle: TextStyle(fontSize: 14),
                                  prefixIcon: Icon(Icons.search, color: Colors.orange),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchKeyword = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.orange),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Giohang()),
                                    ).then((_) => fetchCartItemCount());
                                  },
                                ),
                              ),
                              if (_cartItemCount > 0)
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1.5),
                                    ),
                                    child: Text(
                                      '$_cartItemCount',
                                      style: const TextStyle(color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        _currentIndex == 1
                            ? 'Thông tin cá nhân'
                            : _currentIndex == 2
                                ? 'Đơn hàng'
                                : 'Cài đặt',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
          ),
          Expanded(child: _tabs[_currentIndex]),
        ],
      ),
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
