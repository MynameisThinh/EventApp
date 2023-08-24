import 'package:event_createapp/auth.dart';
import 'package:event_createapp/constants/colors.dart';
import 'package:event_createapp/containers/custom_input_form.dart';
import 'package:event_createapp/ui/checksessions.dart';
import 'package:event_createapp/ui/signup.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            const Text(
              "Đăng nhập",
              style: TextStyle(
                  color: kLightGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomInputForm(
                controller: _emailController,
                icon: Icons.email,
                label: "Email",
                hint: "Nhập Email của bạn"),
            const SizedBox(
              height: 8,
            ),
            CustomInputForm(
              obscureText: true,
                controller: _passwordController,
                icon: Icons.lock_outline_rounded,
                label: "Mật khẩu",
                hint: "Nhập mật khẩu của bạn"),
            const SizedBox(
              height: 8,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Quên mật khẩu ?",
                  style: TextStyle(
                      color: kLightGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  loginUser(_emailController.text, _passwordController.text)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Đăng nhập thành công")));
                          Future.delayed(Duration(seconds: 2), () =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CheckSession())));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Đăng nhập thất bại. Vui lòng thử lại")));
                    }
                  });
                },
                child: Text("Đăng nhập"),
                style: OutlinedButton.styleFrom(
                    foregroundColor: kLightGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () =>   Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tạo tài khoản mới?",
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    "Đăng ký",
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
