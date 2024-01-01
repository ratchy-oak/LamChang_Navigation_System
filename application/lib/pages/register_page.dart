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
  bool usernamevalidate = false;
  bool checkusername = false;
  bool switchusernameerror = false;
  String usernameerrormessage = "";
  bool passwordvalidate = false;
  bool confirmpasswordvalidate = false;
  bool checkpassword = false;
  bool switchpassworderror = false;
  String passworderrormessage = "";
  bool typevalidate = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  void registerUser() async {
    if (usernameController.text.isEmpty) {
      setState(() {
        usernamevalidate = true;
      });
    } else {
      setState(() {
        usernamevalidate = false;
      });
    }

    if (usernamevalidate == true || checkusername == true) {
      if (usernamevalidate == true) {
        usernameerrormessage = "กรุณาป้อนชื่อผู้ใช้";
        setState(() {
          switchusernameerror = true;
        });
      } else {
        usernameerrormessage = "มีชื่อผู้ใช้นี้ในระบบแล้ว";
        setState(() {
          switchusernameerror = true;
          checkusername = false;
        });
        return;
      }
    } else {
      setState(() {
        switchusernameerror = false;
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordvalidate = true;
      });
    } else {
      setState(() {
        passwordvalidate = false;
      });
    }

    if (confirmpasswordController.text.isEmpty) {
      setState(() {
        confirmpasswordvalidate = true;
      });
    } else {
      setState(() {
        confirmpasswordvalidate = false;
      });
    }

    if (passwordController.text != confirmpasswordController.text) {
      setState(() {
        checkpassword = true;
      });
    } else {
      setState(() {
        checkpassword = false;
      });
    }

    if (confirmpasswordvalidate == true || checkpassword == true) {
      if (confirmpasswordvalidate == true) {
        passworderrormessage = "กรุณายืนยันรหัสผ่าน";
        setState(() {
          switchpassworderror = true;
        });
      } else {
        passworderrormessage = "รหัสผ่านไม่ตรงกัน";
        setState(() {
          switchpassworderror = true;
        });
      }
    } else {
      setState(() {
        switchpassworderror = false;
      });
    }

    if (type == Type.none) {
      setState(() {
        typevalidate = true;
      });
    } else {
      setState(() {
        typevalidate = false;
      });
    }

    if (usernameController.text.isNotEmpty &&
        checkusername == false &&
        passwordController.text.isNotEmpty &&
        confirmpasswordController.text.isNotEmpty &&
        checkpassword == false &&
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
          checkusername = true;
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
                                        errorText: switchusernameerror
                                            ? usernameerrormessage
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
                                        errorText: passwordvalidate
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
                                        errorText: switchpassworderror
                                            ? passworderrormessage
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
                                                  "ผู้ประสบเหตุ",
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
                                        typevalidate
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
