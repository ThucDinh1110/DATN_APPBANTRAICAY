import 'package:apptraicay/chitietdonhang.dart';
import 'package:apptraicay/huydonserve.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
}

class DonHangModel {
  final int donhangId;
  final String ngayDat;
  final double tongTien;
  final String trangThai;
  final String diaChi;
  final String ghichu;
  final List<ProductItemModel> sanPhams;

  DonHangModel({
    required this.donhangId,
    required this.ngayDat,
    required this.tongTien,
    required this.trangThai,
    required this.diaChi,
    required this.ghichu,
    required this.sanPhams,
  });
}

class Donhang extends StatefulWidget {
  const Donhang({super.key});

  @override
  _DonhangState createState() => _DonhangState();
}

class _DonhangState extends State<Donhang> {
  List<DonHangModel> choDuyet = [];
  List<DonHangModel> daDuyet = [];
  List<DonHangModel> dangGiao = [];
  List<DonHangModel> daMua = [];
  List<DonHangModel> donHangDaHuy = [];

  @override
  void initState() {
    super.initState();
    fetchDonHang();
  }

  Future<void> fetchDonHang() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getDanhSachDonHang?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      choDuyet.clear();
      daDuyet.clear();
      dangGiao.clear();
      daMua.clear();
      donHangDaHuy.clear();

      final data = jsonDecode(response.body);
      for (var don in data) {
        List<ProductItemModel> items = [];
        for (var item in don['Sanphams']) {
          items.add(ProductItemModel(
            id: 0,
            productName: item['Tensp'],
            price: double.tryParse(item['Gia'].toString()) ?? 0,
            quantity: item['Soluong'],
          ));
        }

        DonHangModel newDon = DonHangModel(
          donhangId: don['DonhangID'],
          ngayDat: don['Ngaydat'],
          tongTien: double.tryParse(don['Tongtien'].toString()) ?? 0,
          trangThai: don['Trangthai'],
          diaChi: don.containsKey('Diachi') ? don['Diachi'] ?? '' : '',
          ghichu: don['Ghichu'],
          sanPhams: items,
        );

        final status = don['Trangthai'].toString().trim().toLowerCase();

        if (status == 'chờ duyệt') {
          choDuyet.add(newDon);
        } else if (status == 'đã duyệt') {
          daDuyet.add(newDon);
        } else if (status == 'đang giao') {
          dangGiao.add(newDon);
        } else if (status == 'đã mua') {
          daMua.add(newDon);
        } else if (status == 'đã hủy' || status.contains('hủy')) {
          donHangDaHuy.add(newDon);
        } else {
          print("Trạng thái không khớp: ${don['Trangthai']}");
        }
      }
      setState(() {});
    } else {
      print('Lỗi khi lấy dữ liệu: ${response.body}');
    }
  }

  Widget _buildOrderStatusList(String title, List<DonHangModel> donHangs) {
    return donHangs.isEmpty
        ? Center(child: Text("Không có đơn nào trong mục '$title'"))
        : ListView.builder(
            itemCount: donHangs.length,
            itemBuilder: (context, index) {
              final don = donHangs[index];
              final isCancelable =
                  don.trangThai.toLowerCase().trim() == 'chờ duyệt';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  title: Text("Ngày đặt: ${don.ngayDat}"),
                  subtitle:
                      Text("Tổng tiền: ${don.tongTien.toStringAsFixed(0)} đ"),
                  trailing: isCancelable
                      ? TextButton(
                          onPressed: () async {
                            final message = await HuyDonService.huyDonHang(
                                don.donhangId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                            fetchDonHang();
                          },
                          child: const Text("Hủy đơn",
                              style: TextStyle(color: Colors.red)),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChiTietDonHangScreen(
                          ngayDat: don.ngayDat,
                          tongTien: don.tongTien,
                          sanPhams: don.sanPhams,
                          diaChi: don.diaChi,
                          ghichu: don.ghichu,
                        ),
                      ),
                    );
                  },
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
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
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderStatusList("Chờ duyệt", choDuyet),
                  _buildOrderStatusList("Đã duyệt", daDuyet),
                  _buildOrderStatusList("Đang giao", dangGiao),
                  _buildOrderStatusList("Đã mua", daMua),
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
