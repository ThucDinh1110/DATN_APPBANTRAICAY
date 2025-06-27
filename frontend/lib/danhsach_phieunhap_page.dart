import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
class DanhSachPhieuNhapPage extends StatefulWidget {
  @override
  _DanhSachPhieuNhapPageState createState() => _DanhSachPhieuNhapPageState();
}

class _DanhSachPhieuNhapPageState extends State<DanhSachPhieuNhapPage> {
  List<dynamic> danhSach = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPhieuNhap();
  }

  Future<void> fetchPhieuNhap() async {
    try {
      final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/phieunhap'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        setState(() {
          danhSach = data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void showChiTiet(BuildContext context, int id) async {
    final res = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/phieunhap/$id'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final List chitiet = data['chi_tiet'] ?? data['chiTiet'] ?? [];

      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chi tiết phiếu nhập #$id', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Divider(),
              ...chitiet.map((item) => ListTile(
                    title: Text(item['SanphamID'].toString() + ' - ' + (item['Tensp'] ?? '')),
                    subtitle: Text('Số lượng: ${item['Soluongnhap']} - Đơn giá: ${item['Dongianhap']}'),
                  )),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: fetchPhieuNhap,
            child: ListView.builder(
              itemCount: danhSach.length,
              itemBuilder: (context, index) {
                final item = danhSach[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('Phiếu nhập #${item['PhieunhapID']}'),
                    subtitle: Text('Nhà cung cấp: ${item['Nhacungcap']}\nNgười nhập: ${item['Nguoinhap']}'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => showChiTiet(context, item['PhieunhapID']),
                  ),
                );
              },
            ),
          );
  }
}
