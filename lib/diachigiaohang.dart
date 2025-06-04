import 'package:flutter/material.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  List<String> savedAddresses = [
    "123 Nguyễn Trãi, Quận 5, TP.HCM",
    "45 Lê Lợi, Quận 1, TP.HCM",
  ];

  int? selectedIndex;
  final TextEditingController _newAddressController = TextEditingController();

  void _confirmAddress() {
    String? selectedAddress;

    if (selectedIndex != null) {
      selectedAddress = savedAddresses[selectedIndex!];
    } else if (_newAddressController.text.isNotEmpty) {
      selectedAddress = _newAddressController.text;
    }

    if (selectedAddress != null && selectedAddress.isNotEmpty) {
      // TODO: Chuyển sang bước thanh toán và truyền selectedAddress
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Địa chỉ được chọn"),
          content: Text(selectedAddress!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn hoặc nhập địa chỉ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Địa chỉ giao hàng"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn địa chỉ có sẵn:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...List.generate(savedAddresses.length, (index) {
              return ListTile(
                title: Text(savedAddresses[index]),
                leading: Radio<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value;
                      _newAddressController.clear(); // bỏ địa chỉ nhập tay nếu chọn sẵn
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 16),
            const Text(
              "Hoặc nhập địa chỉ mới:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _newAddressController,
              onChanged: (_) {
                setState(() {
                  selectedIndex = null; // bỏ chọn sẵn nếu nhập tay
                });
              },
              decoration: const InputDecoration(
                hintText: "Nhập địa chỉ mới...",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _confirmAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Tiếp tục", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
