import 'package:apptraicay/danhsachdiachi.dart';
import 'package:apptraicay/giohang.dart';
import 'package:apptraicay/thanhtoan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'api_config.dart';

class DiaChiGiaoHangScreen extends StatefulWidget {
  final List<ProductItemModel> itemsToBuy;

  const DiaChiGiaoHangScreen({super.key, required this.itemsToBuy});

  @override
  _DiaChiGiaoHangScreenState createState() => _DiaChiGiaoHangScreenState();
}

class _DiaChiGiaoHangScreenState extends State<DiaChiGiaoHangScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController hoTenController = TextEditingController();
  final TextEditingController soDienThoaiController = TextEditingController();
  final TextEditingController diaChiFullController = TextEditingController();
  final TextEditingController ghiChuController = TextEditingController();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    hoTenController.addListener(_validateForm);
    soDienThoaiController.addListener(_validateForm);
    diaChiFullController.addListener(_validateForm);


    fetchAddressFromServer();

  }

  Future<void> fetchAddressFromServer() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  if (userId == null) {
    print('Chưa đăng nhập hoặc không có user_id');
    return;
  }

  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/api/getDanhSachDiaChiGiaoID?user_id=$userId'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final defaultItem = data.firstWhere(
      (item) => item['is_default'] == 1,
      orElse: () => null,
    );

    if (defaultItem != null) {
      setState(() {
        hoTenController.text = defaultItem['hoten'] ?? '';
        soDienThoaiController.text = defaultItem['sdt'] ?? '';
        diaChiFullController.text = defaultItem['diachi'];
      });
    }
  } else {
    print('Không lấy được danh sách địa chỉ');
  }
}

  void _validateForm() {
    final isValid =
        hoTenController.text.trim().isNotEmpty &&
        RegExp(r'^\d{9,11}$').hasMatch(soDienThoaiController.text.trim()) &&
        diaChiFullController.text.trim().isNotEmpty;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    hoTenController.dispose();
    soDienThoaiController.dispose();
    diaChiFullController.dispose();
    ghiChuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập địa chỉ giao hàng',style: TextStyle(color: Colors.white),),
        backgroundColor:const Color(0xFFFF7043), foregroundColor: Colors.white,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(24), // bo cong góc dưới
    ),
    ),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: hoTenController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: soDienThoaiController,
                readOnly: true,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (!RegExp(r'^\d{9,11}$').hasMatch(value.trim())) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Stack(
  alignment: Alignment.centerRight,
  children: [
    TextFormField(
      controller: diaChiFullController,
      readOnly: true,
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: 'Địa chỉ đầy đủ',
        border: OutlineInputBorder(),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.edit_location_alt, color: Colors.orange),
      tooltip: "Chọn địa chỉ khác",
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('user_id');

        if (userId != null) {
          final selected = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DanhSachDiaChiScreen(userId: userId, isSelectMode: true),
            ),
          );

          if (selected != null && mounted) {
            setState(() {
              hoTenController.text = selected['hoten'];
              soDienThoaiController.text = selected['sdt'];
              diaChiFullController.text = selected['diachi'];
              _validateForm(); // cập nhật lại trạng thái nút thanh toán
            });
          }
        }
      },
    ),
  ],
),

              const SizedBox(height: 16),
              TextFormField(
                controller: ghiChuController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú (nếu có)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isFormValid
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThanhToanScreen(
                                itemsToBuy: widget.itemsToBuy,
                                hoten: hoTenController.text,
                                sdt: soDienThoaiController.text,
                                diachi: diaChiFullController.text,
                                ghichu: ghiChuController.text,
                              ),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.payment,color:Colors.white),
                  label: const Text("Thanh toán"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
