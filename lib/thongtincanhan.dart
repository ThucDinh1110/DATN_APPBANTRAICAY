import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'Nguyễn Văn A');
  final TextEditingController _phoneController = TextEditingController(text: '0909123456');
  final TextEditingController _emailController = TextEditingController(text: 'email@example.com');
  //final TextEditingController _addressController = TextEditingController(text: '123 Đường ABC');
  String _gender = 'Nam';
  DateTime _birthDate = DateTime(2000, 1, 1);

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Widget _buildField(String label, TextEditingController controller, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: isMultiline ? null : 1,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField("Họ và tên", _nameController),
            _buildField("Số điện thoại", _phoneController),
            _buildField("Email", _emailController),
            //_buildField("Địa chỉ", _addressController, isMultiline: true),

            // Giới tính
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: DropdownButtonFormField<String>(
                value: _gender,
                items: ['Nam', 'Nữ', 'Khác'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
              ),
            ),

            // Ngày sinh
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Text("Ngày sinh: ", style: TextStyle(fontSize: 16)),
                  Text(
                    "${_birthDate.day}/${_birthDate.month}/${_birthDate.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: const Text("Chọn ngày"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Gửi dữ liệu đi hoặc lưu lại
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Lưu thông tin"),
            ),
          ],
        ),
      ),
    );
  }
}
