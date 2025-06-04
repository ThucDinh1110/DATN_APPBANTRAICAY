import 'package:apptraicay/dangnhap.dart';
import 'package:apptraicay/giohang.dart';
import 'package:apptraicay/quanly.dart';
import 'package:apptraicay/welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginPage()
      ),
    );
  }
}
