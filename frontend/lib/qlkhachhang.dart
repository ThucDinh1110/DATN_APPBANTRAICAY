import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Customer {
  int userId;
  String name;
  String email;
  DateTime birthDate;
  double weight;
  double height;
  String address;
  int cancelCount;
  int status;

  Customer({
    required this.userId,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.address,
    required this.cancelCount,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      userId: json['UserID'] ?? 0,
      name: json['Hoten'] ?? '',
      email: json['Email'] ?? '',
      birthDate: DateTime.tryParse(json['Ngaytao'] ?? '') ?? DateTime.now(),
      height: double.tryParse(json['Chieucao'].toString()) ?? 0,
      weight: double.tryParse(json['Cannang'].toString()) ?? 0,
      address: json['Diachi'] ?? '',
      cancelCount: json['SoLanHuyDon'] ?? 0,
      status: json['Trangthai'] ?? 1,
    );
  }
}

class QuanLyKhachHangAdmin extends StatefulWidget {
  const QuanLyKhachHangAdmin({super.key});

  @override
  State<QuanLyKhachHangAdmin> createState() => _QuanLyKhachHangAdminState();
}

class _QuanLyKhachHangAdminState extends State<QuanLyKhachHangAdmin> {
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/getDanhSachUser'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          customers = data.map((e) => Customer.fromJson(e)).toList();
        });
      } else {
        print('Lỗi khi lấy danh sách người dùng: ${response.body}');
      }
    } catch (e) {
      print('Lỗi khi gọi API: $e');
    }
  }

    Future<void> khoaMoTaiKhoan(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/khoa_moTaiKhoan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật trạng thái tài khoản thành công')),
        );
        fetchCustomers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật trạng thái: \${response.body}')),
        );
      }
    } catch (e) {
      print('Lỗi khi gọi API khóa/mở tài khoản: \$e');
    }
  }

  Widget _buildCustomerCard(Customer customer, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  customer.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        customer.status == 1 ? Icons.lock : Icons.lock_open,
                        color: customer.status == 1 ? Colors.orange : Colors.green,
                        ),
                      tooltip: customer.status == 1 ? 'Khóa tài khoản' : 'Mở khóa tài khoản',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Xác nhận"),
                            content: Text("Bạn có chắc muốn ${customer.status == 1 ? 'khóa' : 'mở'} tài khoản của ${customer.name} không?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Hủy"),
                              ),
                              TextButton(
                                onPressed: () {
                                  khoaMoTaiKhoan(customer.userId);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Xác nhận", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Xóa tài khoản (client only)',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Xác nhận xóa"),
                            content: Text("Bạn có chắc muốn xóa tài khoản của ${customer.name}?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Hủy"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    customers.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text("Email: ${customer.email}"),
            Text("Ngày tạo: ${customer.birthDate.day}/${customer.birthDate.month}/${customer.birthDate.year}"),
            Text("Chiều cao: ${customer.height}cm | Cân nặng: ${customer.weight}kg"),
            Text("Địa chỉ: ${customer.address}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý khách hàng (Admin)"),
      ),
      body: customers.isEmpty
          ? const Center(child: Text("Chưa có khách hàng nào"))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 600,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: customers.length,
                itemBuilder: (context, index) => _buildCustomerCard(customers[index], index),
              ),
            ),
    );
  }
}
