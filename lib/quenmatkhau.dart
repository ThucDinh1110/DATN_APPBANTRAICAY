import 'package:flutter/material.dart';
import 'package:apptraicay/dangnhap.dart';
import 'package:apptraicay/matkhaumoi.dart';

class forgotpasswordPage extends StatefulWidget {
  const forgotpasswordPage({super.key});

  @override
  State<forgotpasswordPage> createState() => _forgotpasswordPageState();
}

class _forgotpasswordPageState extends State<forgotpasswordPage> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _buttonScale = 0.8;
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();

    // Bắt đầu animation fade-in cho container
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
        _buttonScale = 1.0;
      });
    });
  }

  void _onSendPressed() async {
    setState(() {
      _buttonPressed = true;
      _buttonScale = 0.95;
    });

    await Future.delayed(const Duration(milliseconds: 100));

    setState(() {
      _buttonScale = 1.0;
      _buttonPressed = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => const newpasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8E6A3),
      body: Stack(
        children: [
          // Nút quay lại nằm ở ngoài nền trắng
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 6, 0, 0), size: 30),
              onPressed: () {
<<<<<<< HEAD
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
=======
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
>>>>>>> 1bf6a8d (Cap nhat cua thuc lan 2)
              },
            ),
          ),

          // Phần khung trắng đăng nhập với animation opacity
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
<<<<<<< HEAD
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
=======
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Gửi xác nhận thành công'),
                            content: const Text('Vui lòng nhập lại mật khẩu mới.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // đóng dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => newpasswordPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
>>>>>>> 1bf6a8d (Cap nhat cua thuc lan 2)
                        ),
                      ),
<<<<<<< HEAD
                      const SizedBox(height: 24),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nút Send với animation scale
                      AnimatedScale(
                        scale: _buttonScale,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        child: ElevatedButton(
                          onPressed: _buttonPressed ? null : _onSendPressed,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Send"),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
=======
                      child: const Text("Send"),
                    ),
                    const SizedBox(height: 16),
                  ],
>>>>>>> 1bf6a8d (Cap nhat cua thuc lan 2)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
