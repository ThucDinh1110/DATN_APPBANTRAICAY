import 'dart:convert';
import 'dart:async'; // Thêm import này để dùng Timer
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProductItem {
  final String tenSp;
  final int soLuong;
  final double gia;

  ProductItem({required this.tenSp, required this.soLuong, required this.gia});

  double get thanhTien => soLuong * gia;

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      tenSp: json['Tensp'] ?? '',
      soLuong: json['Soluong'] ?? 0,
      gia: double.tryParse(json['Gia'].toString()) ?? 0,
    );
  }
}

class DonHangAdmin {
  final int donhangId;
  final String maDonHang;
  final String trangThai;
  final String phuongThucThanhToan;
  final String khachHang;
  final String email;
  final String diaChi;
  final DateTime ngayDat;
  final double tongTien;
  final List<ProductItem> sanPhams;
  final String? ghiChu;

  DonHangAdmin({
    required this.donhangId,
    required this.maDonHang,
    required this.trangThai,
    required this.phuongThucThanhToan,
    required this.khachHang,
    required this.email,
    required this.diaChi,
    required this.ngayDat,
    required this.tongTien,
    required this.sanPhams,
    this.ghiChu,
  });

  factory DonHangAdmin.fromJson(Map<String, dynamic> json) {
    final nguoiDung = json['NguoiDung'] as Map<String, dynamic>? ?? {};
    final sanphamList = json['Sanphams'] as List? ?? [];

    return DonHangAdmin(
      donhangId: json['DonhangID'] ?? 0,
      maDonHang: json['MaDonHang'] ?? '',
      trangThai: json['Trangthai'] ?? '',
      phuongThucThanhToan: json['PhuongthucThanhToan'] ?? '',
      khachHang: nguoiDung['Hoten'] ?? '',
      email: nguoiDung['Email'] ?? '',
      diaChi: json['Diachi'] ?? '',
      ngayDat: DateTime.tryParse(json['Ngaydat'] ?? '') ?? DateTime.now(),
      tongTien: double.tryParse(json['Tongtien'].toString()) ?? 0,
      sanPhams: sanphamList.map((sp) => ProductItem.fromJson(sp)).toList(),
      ghiChu: json['Ghichu'],
    );
  }
}

class QuanLyDonHangAdmin extends StatefulWidget {
  const QuanLyDonHangAdmin({super.key});

  @override
  State<QuanLyDonHangAdmin> createState() => _QuanLyDonHangAdminState();
}

class _QuanLyDonHangAdminState extends State<QuanLyDonHangAdmin> {
  List<DonHangAdmin> choDuyet = [];
  List<DonHangAdmin> daDuyet = [];
  List<DonHangAdmin> dangGiao = [];
  List<DonHangAdmin> daMua = [];
  List<DonHangAdmin> daHuy = [];
  String keyword = '';
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    fetchDonHangAdmin();
    _autoRefreshTimer = Timer.periodic(Duration(seconds: 30), (_) => fetchDonHangAdmin());
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchDonHangAdmin() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/getDanhSachDonHangTatCa'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        choDuyet.clear();
        daDuyet.clear();
        dangGiao.clear();
        daMua.clear();
        daHuy.clear();

        for (var don in data) {
          try {
            final newDon = DonHangAdmin.fromJson(don);
            final status = newDon.trangThai.toLowerCase().trim();

            if (status == 'chờ duyệt' || status == 'đang chờ hủy') {
              choDuyet.add(newDon);
            } else if (status == 'đã duyệt') {
              daDuyet.add(newDon);
            } else if (status == 'đang giao') {
              dangGiao.add(newDon);
            } else if (status == 'đã mua') {
              daMua.add(newDon);
            } else if (status == 'đã hủy' || status.contains('hủy')) {
              daHuy.add(newDon);
            }
          } catch (e) {
            print('❗ Lỗi xử lý đơn hàng: $e');
          }
        }

        setState(() {});
      }
    } catch (e) {
      print('❗ Lỗi kết nối hoặc xử lý: $e');
    }
  }

  void capNhatTrangThai(int donhangId, String trangThaiMoi) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/capNhatTrangThaiDon'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'donhang_id': donhangId,
        'trangthai': trangThaiMoi,
      }),
    );

    if (res.statusCode == 200) {
      fetchDonHangAdmin();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật thất bại: ${res.body}')),
      );
    }
  }

  Widget _buildList(String title, List<DonHangAdmin> donHangs) {
    final filtered = keyword.isEmpty
        ? donHangs
        : donHangs.where((d) => d.maDonHang.toLowerCase().contains(keyword.toLowerCase())).toList();

    return filtered.isEmpty
        ? Center(child: Text("Không có đơn hàng trong mục '$title'"))
        : ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final don = filtered[index];
              final status = don.trangThai.toLowerCase().trim();
              List<Widget> actions = [];

              if (status == 'chờ duyệt') {
                actions = [
                  TextButton(
                    onPressed: () {
                      capNhatTrangThai(don.donhangId, 'Đã duyệt');
                      Navigator.pop(context);
                    },
                    child: const Text('Xác nhận'),
                  ),
                  TextButton(
                    onPressed: () {
                      capNhatTrangThai(don.donhangId, 'Đã hủy');
                      Navigator.pop(context);
                    },
                    child: const Text('Hủy đơn'),
                  ),
                ];
              } else if (status == 'đang chờ hủy') {
                actions = [
                  TextButton(
                    onPressed: () {
                      capNhatTrangThai(don.donhangId, 'Đã hủy');
                      Navigator.pop(context);
                    },
                    child: const Text('Xác nhận'),
                  ),
                  TextButton(
                    onPressed: () {
                      capNhatTrangThai(don.donhangId, 'Chờ duyệt');
                      Navigator.pop(context);
                    },
                    child: const Text('Hủy đơn'),
                  ),
                ];
              } else if (status == 'đã duyệt') {
                actions = [
                  TextButton(
                    onPressed: () {
                      capNhatTrangThai(don.donhangId, 'Đang giao');
                      Navigator.pop(context);
                    },
                    child: const Text('Xác nhận'),
                  ),
                ];
              } else if (status == 'đang giao') {
                actions = [
                  TextButton(
                    onPressed: () {
                      capNhatTrangThai(don.donhangId, 'Đã mua');
                      Navigator.pop(context);
                    },
                    child: const Text('Xác nhận'),
                  ),
                ];
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  title: Text("Mã đơn: ${don.maDonHang} | Ngày đặt: ${don.ngayDat}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Khách hàng: ${don.khachHang}"),
                      Text("Email: ${don.email}"),
                      Text("Tổng tiền: ${don.tongTien.toStringAsFixed(0)}đ"),
                      Text("Trạng thái: ${don.trangThai}"),
                      Text("Phương thức thanh toán: ${don.phuongThucThanhToan}"),
                      if (don.ghiChu != null && don.ghiChu!.isNotEmpty)
                        Text("Ghi chú: ${don.ghiChu}"),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Đơn hàng #${don.maDonHang}"),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Khách: ${don.khachHang}"),
                              Text("Email: ${don.email}"),
                              Text("Địa chỉ: ${don.diaChi}"),
                              Text("Phương thức thanh toán: ${don.phuongThucThanhToan}"),
                              if (don.ghiChu != null && don.ghiChu!.isNotEmpty)
                                Text("Ghi chú: ${don.ghiChu}"),
                              const Divider(),
                              const Text("Sản phẩm:",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              ...don.sanPhams.map((sp) => Text(
                                  "- ${sp.tenSp}: ${sp.soLuong} x ${sp.gia.toStringAsFixed(0)}đ = ${sp.thanhTien.toStringAsFixed(0)}đ")),
                              const SizedBox(height: 12),
                              Text(
                                "Tổng tiền: ${don.tongTien.toStringAsFixed(0)}đ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ...actions,
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Đóng"),
                          ),
                        ],
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
        appBar: AppBar(
          title: const Text('Quản lý đơn hàng (Admin)', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF26A69A),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Chờ duyệt'),
              Tab(text: 'Đã duyệt'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã mua'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Tìm theo mã đơn hàng',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList('Chờ duyệt', choDuyet),
                  _buildList('Đã duyệt', daDuyet),
                  _buildList('Đang giao', dangGiao),
                  _buildList('Đã mua', daMua),
                  _buildList('Đã hủy', daHuy),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
