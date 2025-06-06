import 'package:flutter/material.dart';

class Customer {
  String name;
  String phone;
  DateTime birthDate;
  double weight;
  double height;
  String address;
  String gender;
  String demand;
  String email;
  String password;

  Customer({
    required this.name,
    required this.phone,
    required this.birthDate,
    required this.weight,
    required this.height,
    required this.address,
    required this.gender,
    required this.demand,
    required this.email,
    required this.password,
  });
}

class QuanLyKhachHangAdmin extends StatefulWidget {
  const QuanLyKhachHangAdmin({super.key});

  @override
  State<QuanLyKhachHangAdmin> createState() => _QuanLyKhachHangAdminState();
}

class _QuanLyKhachHangAdminState extends State<QuanLyKhachHangAdmin> {
  List<Customer> customers = [
    Customer(
      name: "Nguyễn Văn A",
      phone: "0123456789",
      birthDate: DateTime(1995, 5, 20),
      weight: 60,
      height: 170,
      address: "Hà Nội",
      gender: "Nam",
      demand: "Giảm cân",
      email: "vana@example.com",
      password: "123456",
    ),
     Customer(
      name: "Nguyễn Văn A",
      phone: "0123456789",
      birthDate: DateTime(1995, 5, 20),
      weight: 60,
      height: 170,
      address: "Hà Nội",
      gender: "Nam",
      demand: "Giảm cân",
      email: "vana@example.com",
      password: "123456",
    ),
     Customer(
      name: "Nguyễn Văn A",
      phone: "0123456789",
      birthDate: DateTime(1995, 5, 20),
      weight: 60,
      height: 170,
      address: "Hà Nội",
      gender: "Nam",
      demand: "Giảm cân",
      email: "vana@example.com",
      password: "123456",
    ),
  ];

  void _showCustomerDialog({Customer? customer, int? index}) {
    final isEditing = customer != null;
    final nameController = TextEditingController(text: customer?.name);
    final phoneController = TextEditingController(text: customer?.phone);
    final birthController = TextEditingController(
      text: customer != null
          ? "${customer.birthDate.day}/${customer.birthDate.month}/${customer.birthDate.year}"
          : "",
    );
    final weightController =
        TextEditingController(text: customer?.weight.toString());
    final heightController =
        TextEditingController(text: customer?.height.toString());
    final addressController = TextEditingController(text: customer?.address);
    final genderController = TextEditingController(text: customer?.gender);
    final demandController = TextEditingController(text: customer?.demand);
    final emailController = TextEditingController(text: customer?.email);
    final passwordController = TextEditingController(text: customer?.password);

    DateTime selectedDate = customer?.birthDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? "Chỉnh sửa khách hàng" : "Thêm khách hàng",
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: "Tên"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: "SĐT"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: birthController,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: "Ngày sinh"),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            selectedDate = picked;
                            birthController.text =
                                "${picked.day}/${picked.month}/${picked.year}";
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: weightController,
                        decoration: const InputDecoration(labelText: "Cân nặng (kg)"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: heightController,
                        decoration: const InputDecoration(labelText: "Chiều cao (cm)"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: "Địa chỉ"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: genderController,
                        decoration: const InputDecoration(labelText: "Giới tính"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: demandController,
                        decoration: const InputDecoration(labelText: "Nhu cầu"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(labelText: "Mật khẩu"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Hủy"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final newCustomer = Customer(
                          name: nameController.text,
                          phone: phoneController.text,
                          birthDate: selectedDate,
                          weight: double.tryParse(weightController.text) ?? 0,
                          height: double.tryParse(heightController.text) ?? 0,
                          address: addressController.text,
                          gender: genderController.text,
                          demand: demandController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );

                        setState(() {
                          if (isEditing && index != null) {
                            customers[index] = newCustomer;
                          } else {
                            customers.add(newCustomer);
                          }
                        });

                        Navigator.pop(context);
                      },
                      child: Text(isEditing ? "Lưu" : "Thêm"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(customer.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showCustomerDialog(customer: customer, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          customers.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text("SĐT: ${customer.phone}"),
            Text("Ngày sinh: ${customer.birthDate.day}/${customer.birthDate.month}/${customer.birthDate.year}"),
            Text("Giới tính: ${customer.gender} | Nhu cầu: ${customer.demand}"),
            Text("Chiều cao: ${customer.height}cm | Cân nặng: ${customer.weight}kg"),
            Text("Địa chỉ: ${customer.address}"),
            Text("Email: ${customer.email}"),
            Text("Mật khẩu: ${customer.password}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý khách hàng (Admin)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCustomerDialog(),
          ),
        ],
      ),
      body: customers.isEmpty
          ? const Center(child: Text("Chưa có khách hàng nào"))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 600,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: customers.length,
                itemBuilder: (context, index) => _buildCustomerCard(customers[index], index),
              ),
            ),
    );
  }
}
