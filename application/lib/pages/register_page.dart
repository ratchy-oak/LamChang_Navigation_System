import 'dart:convert';
import 'package:application/pages/login_page.dart';
import 'package:application/styles/app_colors.dart';
import 'package:application/styles/app_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

enum Type { none, user, helper }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var type = Type.none;
  bool _isSecurePassword = true;
  bool usernameValidate = false;
  bool checkUsername = false;
  bool switchUsernameError = false;
  String usernameErrorMessage = "";
  bool passwordValidate = false;
  bool confirmPasswordValidate = false;
  bool checkPassword = false;
  bool switchPasswordError = false;
  String passwordErrorMessage = "";
  bool typeValidate = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  void registerUser() async {
    if (usernameController.text.isEmpty) {
      setState(() {
        usernameValidate = true;
      });
    } else {
      setState(() {
        usernameValidate = false;
      });
    }

    if (usernameValidate == true || checkUsername == true) {
      if (usernameValidate == true) {
        usernameErrorMessage = "กรุณาป้อนชื่อผู้ใช้";
        setState(() {
          switchUsernameError = true;
        });
      } else {
        usernameErrorMessage = "มีชื่อผู้ใช้นี้ในระบบแล้ว";
        setState(() {
          switchUsernameError = true;
          checkUsername = false;
        });
        return;
      }
    } else {
      setState(() {
        switchUsernameError = false;
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

    if (confirmpasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordValidate = true;
      });
    } else {
      setState(() {
        confirmPasswordValidate = false;
      });
    }

    if (passwordController.text != confirmpasswordController.text) {
      setState(() {
        checkPassword = true;
      });
    } else {
      setState(() {
        checkPassword = false;
      });
    }

    if (confirmPasswordValidate == true || checkPassword == true) {
      if (confirmPasswordValidate == true) {
        passwordErrorMessage = "กรุณายืนยันรหัสผ่าน";
        setState(() {
          switchPasswordError = true;
        });
      } else {
        passwordErrorMessage = "รหัสผ่านไม่ตรงกัน";
        setState(() {
          switchPasswordError = true;
        });
      }
    } else {
      setState(() {
        switchPasswordError = false;
      });
    }

    if (type == Type.none) {
      setState(() {
        typeValidate = true;
      });
    } else {
      setState(() {
        typeValidate = false;
      });
    }

    if (usernameController.text.isNotEmpty &&
        checkUsername == false &&
        passwordController.text.isNotEmpty &&
        confirmpasswordController.text.isNotEmpty &&
        checkPassword == false &&
        type != Type.none) {
      String typevalue = "";
      switch (type) {
        case Type.user:
          typevalue = "user";
          break;
        case Type.helper:
          typevalue = "helper";
          break;
        default:
          typevalue = "";
      }
      var regBody = {
        "username": usernameController.text,
        "password": passwordController.text,
        "type": typevalue,
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        setState(() {
          checkUsername = true;
        });
        registerUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    "สมัครสมาชิก",
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
                                        hintStyle: const TextStyle(
                                          color: AppColors.grey,
                                        ),
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: switchUsernameError
                                            ? usernameErrorMessage
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
                                        hintStyle: const TextStyle(
                                          color: AppColors.grey,
                                        ),
                                        border: InputBorder.none,
                                        suffixIcon: togglePassword(),
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: passwordValidate
                                            ? "กรุณาป้อนรหัสผ่าน"
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
                                      controller: confirmpasswordController,
                                      obscureText: _isSecurePassword,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        hintText: "ยืนยันรหัสผ่าน",
                                        hintStyle: const TextStyle(
                                          color: AppColors.grey,
                                        ),
                                        border: InputBorder.none,
                                        suffixIcon: togglePassword(),
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: switchPasswordError
                                            ? passwordErrorMessage
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
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: RadioListTile(
                                                activeColor: AppColors.yellow,
                                                title: const Text(
                                                  "บุคคลทั่วไป",
                                                  style: AppText.body,
                                                ),
                                                value: Type.user,
                                                visualDensity:
                                                    const VisualDensity(
                                                  horizontal: VisualDensity
                                                      .minimumDensity,
                                                  vertical: VisualDensity
                                                      .minimumDensity,
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                                groupValue: type,
                                                onChanged: (value) {
                                                  setState(() {
                                                    type = Type.user;
                                                  });
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: RadioListTile(
                                                activeColor: AppColors.yellow,
                                                title: const Text(
                                                  "เจ้าหน้าที่",
                                                  style: AppText.body,
                                                ),
                                                value: Type.helper,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                        vertical: VisualDensity
                                                            .minimumDensity),
                                                contentPadding: EdgeInsets.zero,
                                                groupValue: type,
                                                onChanged: (value) {
                                                  setState(() {
                                                    type = Type.helper;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        typeValidate
                                            ? const Text("กรุณาเลือกบทบาท",
                                                style: AppText.error)
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 55,
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
                                  registerUser();
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: const Center(
                                  child: Text(
                                    "สมัครสมาชิก",
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
                                "มีบัญชีแล้ว ?",
                                style: AppText.body,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.green,
                                ),
                                child: const Text("เข้าสู่ระบบ"),
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
