import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFA726), // Cam tươi
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class ThanhToanScreen extends StatefulWidget {
  const ThanhToanScreen({super.key});

  @override
  State<ThanhToanScreen> createState() => _ThanhToanScreenState();
}

class _ThanhToanScreenState extends State<ThanhToanScreen> {
  final TextEditingController tenController = TextEditingController();
  final TextEditingController sdtController = TextEditingController();
  final TextEditingController diachiController = TextEditingController();

  int _selectedPaymentMethod = 1;
  int totalAmount = 120000;
  int discountPercent = 10;

  @override
  void initState() {
    super.initState();
    tenController.text = "Nguyễn Văn A";
    sdtController.text = "0123456789";
    diachiController.text = "123 Đường ABC, Quận 1, TP.HCM";
  }

  @override
  Widget build(BuildContext context) {
    double discountAmount = totalAmount * discountPercent / 100;
    double finalAmount = totalAmount - discountAmount;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // nền kem cam nhẹ
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7043), // cam đậm
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
              title: "Phương Thức Thanh Toán",
              icon: Icons.payment,
              child: Column(
                children: [
                  RadioListTile(
                    value: 1,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("💳 Chuyển Khoản"),
                    activeColor: const Color(0xFFFF7043),
                    onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: _selectedPaymentMethod,
                    title: const Text("💵 Tiền Mặt (Sau khi nhận hàng)"),
                    activeColor: const Color(0xFFFF7043),
                    onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
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
                    Text("Tổng tiền: ${totalAmount.toStringAsFixed(0)} đ"),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Text("💸 "),
                    Text("Giảm giá: -${discountAmount.toStringAsFixed(0)} đ"),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Text("✅ "),
                    Text(
                      "Thành tiền: ${finalAmount.toStringAsFixed(0)} đ",
                      style: const TextStyle(fontSize: 16, color: Color(0xFFFF5722), fontWeight: FontWeight.bold),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomButton(
              text: "Thanh Toán",
              onPressed: () => _showConfirmDialog(context, finalAmount),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    Icon? prefixIcon;
    if (label.contains("Tên")) {
      prefixIcon = const Icon(Icons.person);
    } else if (label.contains("Số")) {
      prefixIcon = const Icon(Icons.phone);
    } else if (label.contains("Địa")) {
      prefixIcon = const Icon(Icons.location_on);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFFFCCBC)), // border cam nhạt
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
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác Nhận Thanh Toán"),
        content: Text(
          "Bạn có chắc muốn thanh toán ${amount.toStringAsFixed(0)} đ bằng "
          "${_selectedPaymentMethod == 1 ? "Chuyển Khoản" : "Tiền Mặt"}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thanh toán thành công!')),
              );
            },
            child: const Text("Xác Nhận"),
          ),
        ],
      ),
    );
  }
}
