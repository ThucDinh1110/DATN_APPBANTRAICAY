import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'giohang.dart';
import 'api_config.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class QrCodeScreen extends StatefulWidget {
  final int finalAmount;
  final int paymentMethod;
  final String hoten;
  final String sdt;
  final String diachi;
  final String ghichu;
  final List<ProductItemModel> itemsToBuy;

  const QrCodeScreen({
    super.key,
    required this.finalAmount,
    required this.paymentMethod,
    required this.hoten,
    required this.sdt,
    required this.diachi,
    required this.ghichu,
    required this.itemsToBuy,
  });

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String? _maDonHang;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _createOrder();
  }

  Future<void> _createOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      _showError('Không tìm thấy user_id');
      return;
    }

    final diachiRes = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/getDiaChiGiaoID?user_id=$userId'),
    );

    if (diachiRes.statusCode != 200) {
      _showError('Không lấy được địa chỉ giao hàng');
      return;
    }

    final diachiGiaoId = jsonDecode(diachiRes.body)['diachi_id'];

    final itemsData = widget.itemsToBuy
        .map((item) => {'sanpham_id': item.id, 'soluong': item.quantity})
        .toList();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/taoDonHang'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'hoten': widget.hoten,
        'sdt': widget.sdt,
        'diachi': widget.diachi,
        'ghichu': widget.ghichu,
        'thanhtoan_id': widget.paymentMethod,
        'tongtien': widget.finalAmount,
        'diachigiao_id': diachiGiaoId,
        'items': itemsData,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _maDonHang = data['MaDonHang'];
        _loading = false;
      });
    } else {
      _showError('Tạo đơn hàng thất bại: ${response.body}');
    }
  }

  void _showError(String message) {
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    Navigator.pop(context);
  }

  Future<void> downloadQrImage(String url, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName.png';

      await Dio().download(url, filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Đã lưu mã QR vào: $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi lưu ảnh: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _maDonHang == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final qrImageUrl = Uri.encodeFull(
      'https://img.vietqr.io/image/VCB-1023400991-compact.png'
      '?amount=${widget.finalAmount}&addInfo=${_maDonHang!}',
    );

    return WillPopScope(
      onWillPop: () async => false, // ⛔ Chặn back
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ⛔ Ẩn nút back
          title: const Text("Mã QR Chuyển Khoản", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFFFF7043),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Quét mã bằng app ngân hàng để chuyển khoản:",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Image.network(qrImageUrl, width: 250),
                const SizedBox(height: 20),
                const Text("Số tài khoản: 1023400991"),
                const Text("Ngân hàng: Vietcombank"),
                const Text("Chủ TK: Nguyễn Phương Nam"),
                const SizedBox(height: 10),
                Text("Số tiền: ${widget.finalAmount} VND"),
                Text("Nội dung: ${_maDonHang!}"),
                const SizedBox(height: 30),
                Row(children: [
                  Expanded(child: 
                  ElevatedButton.icon(
                  onPressed: () => downloadQrImage(qrImageUrl, _maDonHang!),
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text("Lưu mã QR", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),),
               
                Expanded(child: 
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    "✅ Đã Thanh Toán",
                    style: TextStyle(color: Colors.white),
                  ),
                ),),
                ],)
                
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
