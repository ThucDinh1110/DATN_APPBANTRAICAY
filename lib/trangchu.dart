import 'package:apptraicay/dangky.dart';
import 'package:apptraicay/quenmatkhau.dart';
import 'package:apptraicay/welcome.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6A3),
      body: Stack(
        children: [
          // Nút quay lại nằm ở ngoài nền trắng
          // Positioned(
          //   top: 40,
          //   left: 16,
          //   child: IconButton(
          //     icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 6, 0, 0), size: 30),
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage()));
          //     },
          //   ),
          // ),

          // Positioned(
          //   top: 40,
          //   right: 16,
          //   child: TextButton(
          //     onPressed: (){
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
          //     }, 
          //     child: Text(
          //       "Sign Up",
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold
          //       ),
          //     ))),

          // Phần khung trắng đăng nhập
          Center(
            
          ),
        ],
      ),
    );
  }
}
