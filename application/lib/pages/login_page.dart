import 'dart:convert';
import 'package:application/pages/forgetpassword_page.dart';
import 'package:application/pages/helper_page.dart';
import 'package:application/pages/register_page.dart';
import 'package:application/pages/user_page.dart';
import 'package:application/styles/app_colors.dart';
import 'package:application/styles/app_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSecurePassword = true;
  bool usernameValidate = false;
  bool passwordValidate = false;
  bool checkError = false;
  bool switchError = false;
  String errorMessage = "";
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    if (usernameController.text.isEmpty) {
      setState(() {
        usernameValidate = true;
      });
    } else {
      setState(() {
        usernameValidate = false;
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordValidate = true;
      });
    } else {
      setState(() {
        passwordValidate = false;
      });
    }

    if (passwordValidate == true || checkError == true) {
      if (passwordValidate == true) {
        errorMessage = "กรุณาป้อนรหัสผ่าน";
        setState(() {
          switchError = true;
        });
      } else {
        errorMessage = "ชื่อผู้ใช้ หรือ รหัสผ่าน ไม่ถูกต้อง";
        setState(() {
          switchError = true;
          checkError = false;
        });
        return;
      }
    } else {
      setState(() {
        switchError = false;
      });
    }

    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        checkError == false) {
      var reqBody = {
        "username": usernameController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(myToken);
        if (decodedToken['type'] == "user") {
          // ignore: use_build_context_synchronously
          Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                  builder: (context) => UserPage(token: myToken)));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                  builder: (context) => HelperPage(token: myToken)));
        }
      } else {
        setState(() {
          checkError = true;
        });
        loginUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 75,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "เข้าสู่ระบบ",
                    style: AppText.header,
                  ),
                  Text(
                    "ระบบนำทางในชุมชนล่ามช้าง",
                    style: AppText.subtitle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 30),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        hintText: "ชื่อผู้ใช้",
                                        hintStyle: AppText.body,
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: usernameValidate
                                            ? "กรุณาป้อนชื่อผู้ใช้"
                                            : null,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscureText: _isSecurePassword,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: "รหัสผ่าน",
                                        hintStyle: AppText.body,
                                        border: InputBorder.none,
                                        suffixIcon: togglePassword(),
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText:
                                            switchError ? errorMessage : null,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPasswordPage()));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.grey,
                            ),
                            child: const Text(
                              "ลืมรหัสผ่าน ?",
                              style: AppText.body,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.red,
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  loginUser();
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: const Center(
                                  child: Text(
                                    "เข้าสู่ระบบ",
                                    style: AppText.button,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "ยังไม่มีบัญชี ?",
                                style: AppText.body,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage()));
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.green,
                                ),
                                child: const Text("สมัครสมาชิก"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: AppColors.grey,
    );
  }
}
