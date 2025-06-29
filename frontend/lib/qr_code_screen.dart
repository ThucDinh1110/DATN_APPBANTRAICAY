import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'giohang.dart';
import 'api_config.dart';

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

  void _xacNhanDaThanhToan() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green, size: 30),
          const SizedBox(width: 10),
          const Text(
            "Xác nhận thanh toán",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        "Bạn đã hoàn thành chuyển khoản chưa?",
        style: TextStyle(fontSize: 18),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton.icon(
          icon: const Icon(Icons.cancel_outlined),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
          label: const Text("Chưa"),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.check),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          label: const Text("Đã thanh toán"),
        ),
      ],
    ),
  );
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
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Mã QR Chuyển Khoản", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFFFF7043),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.deepOrange, size: 60),
                const SizedBox(height: 10),
                Text(
                  "Lưu lại mã QR Code khi cần",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.network(qrImageUrl, width: 250),
                        const SizedBox(height: 20),
                        InfoRow(label: "💳 Số tài khoản:", value: "1023400991"),
                        InfoRow(label: "🏦 Ngân hàng:", value: "Vietcombank"),
                        InfoRow(label: "👤 Chủ tài khoản:", value: "Nguyễn Phương Nam"),
                        const Divider(thickness: 1),
                        InfoRow(label: "💸 Số tiền:", value: "${widget.finalAmount} VND", highlight: true),
                        InfoRow(label: "📝 Nội dung:", value: _maDonHang!, highlight: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline,color:Colors.white,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5722),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: _xacNhanDaThanhToan,
                  label: const Text(" Tôi đã thanh toán"),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 3, child: Text(label)),
          const SizedBox(width: 5),
          Flexible(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                color: highlight ? Colors.red.shade700 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
