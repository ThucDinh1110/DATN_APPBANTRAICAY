import 'package:apptraicay/dangnhap.dart';
import 'package:apptraicay/donhang.dart';
import 'package:apptraicay/giohang.dart';
<<<<<<< HEAD
import 'package:apptraicay/quanly.dart';
=======
import 'package:apptraicay/trangchu.dart';
>>>>>>> 1bf6a8d (Cap nhat cua thuc lan 2)
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
        body: HomePage()
      ),
    );
  }
}
