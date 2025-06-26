import 'package:apptraicay/giohang.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'qr_code_screen.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA726),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class ThanhToanScreen extends StatefulWidget {
  final List<ProductItemModel> itemsToBuy;
  final String hoten;
  final String sdt;
  final String diachi;
  final String ghichu;

  const ThanhToanScreen({
    super.key,
    required this.itemsToBuy,
    required this.hoten,
    required this.sdt,
    required this.diachi,
    required this.ghichu,
  });

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  int _selectedPaymentMethod = 1;

  int _calculateTotalAmount() {
    return widget.itemsToBuy
        .fold(0, (sum, item) => sum + (item.price * item.quantity).toInt());
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount = _calculateTotalAmount();
    double finalAmount = totalAmount.toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043),
        title: const Text("Thanh Toán", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 15),
            _buildCard(
              title: "Địa chỉ giao hàng",
              icon: Icons.location_on,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.hoten,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("SĐT: ${widget.sdt}"),
                  Text(widget.diachi),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildCard(
              title: "Phương Thức Thanh Toán",
              icon: Icons.payment,
              child: Column(
                children: [
                  RadioListTile(
                    value: 1,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("💳 Chuyển Khoản"),
                    activeColor: const Color(0xFFFF7043),
                    onChanged: (value) =>
                        setState(() => _selectedPaymentMethod = value!),
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("💵 Tiền Mặt (Sau khi nhận hàng)"),
                    activeColor: const Color(0xFFFF7043),
                    onChanged: (value) =>
                        setState(() => _selectedPaymentMethod = value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildCard(
              title: "Chi Tiết Thanh Toán",
              icon: Icons.receipt_long,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text("🧾 "),
                    Text("Tổng tiền: ${totalAmount.toString()} đ")
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Text("✅ "),
                    Text("Thành tiền: ${finalAmount.toStringAsFixed(0)} đ",
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF5722),
                            fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Thanh Toán",
              onPressed: () {
                if (_selectedPaymentMethod == 1) {
                  _confirmChuyenKhoan(finalAmount.toInt());
                } else {
                  _submitOrder(finalAmount.toInt());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFFFCCBC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFFF5722)),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }

  void _confirmChuyenKhoan(int finalAmount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thanh toán'),
        content: const Text(
          'Bạn chắc chắn muốn sử dụng phương thức chuyển khoản? Sau khi xác nhận, bạn sẽ được chuyển sang màn hình hiển thị mã QR để thanh toán.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showQrForChuyenKhoan(finalAmount);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQrForChuyenKhoan(int finalAmount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrCodeScreen(
          finalAmount: finalAmount,
          paymentMethod: _selectedPaymentMethod,
          hoten: widget.hoten,
          sdt: widget.sdt,
          diachi: widget.diachi,
          ghichu: widget.ghichu,
          itemsToBuy: widget.itemsToBuy,
        ),
      ),
    );
  }

  Future<void> _submitOrder(int finalAmount) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy user_id')));
      return;
    }

    final diachiGiaoId = await _getDiaChiGiaoID(userId);
    if (diachiGiaoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy DiachigiaoID')));
      return;
    }

    final itemsData = widget.itemsToBuy
        .map((item) => {'sanpham_id': item.id, 'soluong': item.quantity})
        .toList();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/taoDonHang'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'hoten': widget.hoten,
        'sdt': widget.sdt,
        'diachi': widget.diachi,
        'ghichu': widget.ghichu,
        'thanhtoan_id': _selectedPaymentMethod,
        'tongtien': finalAmount,
        'diachigiao_id': diachiGiaoId,
        'items': itemsData,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đặt hàng thành công!')));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: ${response.body}')));
    }
  }

  Future<int?> _getDiaChiGiaoID(int userId) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getDiaChiGiaoID?user_id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['diachi_id'];
    } else {
      return null;
    }
  }
}