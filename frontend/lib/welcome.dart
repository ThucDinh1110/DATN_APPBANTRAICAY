import 'package:apptraicay/dangky.dart';
import 'package:apptraicay/dangnhap.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final Color buttonColor = Colors.white.withOpacity(0.2); 

    return Scaffold(
      body: Stack(
        children: [
        
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color:  Color.fromRGBO(95, 179, 249, 1),
            child: Align(
              alignment: Alignment.centerLeft, // Canh giữa theo chiều dọc, trái theo chiều ngang
              child: Column(
                mainAxisSize: MainAxisSize.min, // Để căn giữa dọc gọn hơn
                crossAxisAlignment: CrossAxisAlignment.center, // ✅ Căn trái
                children: [
                  Image.asset(
                    "assets/welcome2.jpg",
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                    
                  ),
                
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Đăng Nhập",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      elevation: 3,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Đăng Ký",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

            ),
  
          ),
          
        ],
      ),
     
    );
  }
}
