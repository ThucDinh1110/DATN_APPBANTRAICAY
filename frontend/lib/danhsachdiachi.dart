import 'package:apptraicay/themsuadiachi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DanhSachDiaChiScreen extends StatefulWidget {
  final int userId;
  final bool isSelectMode;

  const DanhSachDiaChiScreen({
    super.key,
    required this.userId,
    this.isSelectMode = false,
  });

  @override
  _DanhSachDiaChiScreenState createState() => _DanhSachDiaChiScreenState();
}

class _DanhSachDiaChiScreenState extends State<DanhSachDiaChiScreen> {
  List<Map<String, dynamic>> danhSach = [];
  int? defaultDiaChiId;

  @override
  void initState() {
    super.initState();
    fetchDiaChi();
  }

  Future<void> fetchDiaChi() async {
    final res = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/getDanhSachDiaChiGiaoID?user_id=${widget.userId}"),
    );
    if (res.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(jsonDecode(res.body));
      setState(() {
        danhSach = data;
        final defaultItem = data.firstWhere(
          (e) => e['is_default'] == 1,
          orElse: () => {},
        );
        defaultDiaChiId = defaultItem.isNotEmpty ? defaultItem['diachi_id'] : null;
      });
    }
  }

  Future<void> setDefault(int diachiId) async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/setDefaultAddress"),
      body: {
        "user_id": widget.userId.toString(),
        "dia_chi_id": diachiId.toString(),
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        defaultDiaChiId = diachiId;
      });
    }
  }

  void _showActionMenu(BuildContext context, Map<String, dynamic> diaChi) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star, color: Colors.orange),
              title: const Text('Đặt làm mặc định'),
              onTap: () async {
                await setDefault(diaChi['diachi_id']);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_location, color: Colors.blue),
              title: const Text('Chỉnh sửa địa chỉ'),
              onTap: () {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditAddressPage(
        diachiId: diaChi['diachi_id'],
        name: diaChi['hoten'],
        phone: diaChi['sdt'],
        address: diaChi['diachi'],
      ),
    ),
  ).then((value) {
    if (value == true) {
      fetchDiaChi(); // làm mới danh sách
    }
  });
},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn địa chỉ nhận hàng")),
      body: ListView.builder(
        itemCount: danhSach.length,
        itemBuilder: (context, index) {
          final diaChi = danhSach[index];
          return ListTile(
            onTap: widget.isSelectMode
                ? () {
                    Navigator.pop(context, diaChi); // chọn để trả về
                  }
                : null,
            leading: Icon(
              diaChi['diachi_id'] == defaultDiaChiId
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: diaChi['diachi_id'] == defaultDiaChiId
                  ? Colors.red
                  : Colors.grey,
            ),
            title: Text(diaChi['hoten']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(diaChi['sdt']),
                Text("${diaChi['diachi']}"),
              ],
            ),
            trailing: widget.isSelectMode
                ? (diaChi['diachi_id'] == defaultDiaChiId
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Mặc định',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      )
                    : null)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (diaChi['diachi_id'] == defaultDiaChiId)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Đã chọn',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                        tooltip: "Sửa địa chỉ",
                        onPressed: () => _showActionMenu(context, diaChi),
                      ),
                    ],
                  ),
          );
        },
      ),
      floatingActionButton: widget.isSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const EditAddressPage(),
    ),
  ).then((value) {
    if (value == true) {
      fetchDiaChi(); // làm mới danh sách
    }
  });
},
              label: const Text('Thêm Địa Chỉ Mới'),
              icon: const Icon(Icons.add),
            ),
    );
  }
}
