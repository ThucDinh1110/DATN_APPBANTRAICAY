import 'package:apptraicay/thanhtoan.dart';
import 'package:flutter/material.dart';

class DiaChiGiaoHangScreen extends StatefulWidget {
  const DiaChiGiaoHangScreen({super.key});

  @override
  _DiaChiGiaoHangScreenState createState() => _DiaChiGiaoHangScreenState();
}

class _DiaChiGiaoHangScreenState extends State<DiaChiGiaoHangScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController hoTenController = TextEditingController();
  final TextEditingController soDienThoaiController = TextEditingController();
  final TextEditingController diaChiController = TextEditingController();
  final TextEditingController quanHuyenController = TextEditingController();
  final TextEditingController thanhPhoController = TextEditingController();
  final TextEditingController ghiChuController = TextEditingController();

  bool _isFormValid = false; // Trạng thái form hợp lệ

  @override
  void initState() {
    super.initState();
    hoTenController.addListener(_validateForm);
    soDienThoaiController.addListener(_validateForm);
    diaChiController.addListener(_validateForm);
    quanHuyenController.addListener(_validateForm);
    thanhPhoController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = 
        hoTenController.text.trim().isNotEmpty &&
        RegExp(r'^\d{9,11}$').hasMatch(soDienThoaiController.text.trim()) &&
        diaChiController.text.trim().isNotEmpty &&
        quanHuyenController.text.trim().isNotEmpty &&
        thanhPhoController.text.trim().isNotEmpty;

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
    diaChiController.dispose();
    quanHuyenController.dispose();
    thanhPhoController.dispose();
    ghiChuController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Xử lý lưu hoặc gửi dữ liệu lên server nếu cần
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thành công'),
          content: const Text('Địa chỉ giao hàng đã được lưu.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Quay lại màn trước
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập địa chỉ giao hàng'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: hoTenController,
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
              TextFormField(
                controller: diaChiController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ (số nhà, tên đường)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: quanHuyenController,
                decoration: const InputDecoration(
                  labelText: 'Quận / Huyện',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập quận/huyện';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: thanhPhoController,
                decoration: const InputDecoration(
                  labelText: 'Thành phố',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập thành phố';
                  }
                  return null;
                },
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
                          _submit();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThanhToanScreen(),
                            ),
                          );
                        }
                      : null, // Disabled nếu chưa hợp lệ
                  icon: const Icon(Icons.payment),
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
