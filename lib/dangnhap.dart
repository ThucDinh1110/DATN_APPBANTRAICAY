import 'package:flutter/material.dart';

class DangNhapPage extends StatelessWidget {
  const DangNhapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 214, 39),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("ĐĂNG NHẬP",style: TextStyle(color: Colors.white, fontSize: 28 ),),
                SizedBox(height: 10,),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Tài Khoản",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Mật khẩu",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: (){}, 
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.white24),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white24),
                     padding: WidgetStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    elevation: WidgetStateProperty.all(4),
                  ),
                  child: Text("Đăng Nhập",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),))
              ],
            )
          ),
        ),
      ),
    );
  }
}