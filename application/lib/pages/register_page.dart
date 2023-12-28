import 'package:application/config/app_routes.dart';
import 'package:application/styles/app_colors.dart';
import 'package:application/styles/app_text.dart';
import 'package:flutter/material.dart';

enum Type { none, user, helper }

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var type = Type.none;
  bool _isSecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
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
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
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
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "ชื่อผู้ใช้",
                                      hintStyle: TextStyle(
                                        color: AppColors.grey,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
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
                                  child: TextField(
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
                                  child: TextField(
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: AppColors.yellow,
                                          title: const Text(
                                            "ผู้ประสบเหตุ",
                                            style: AppText.body,
                                          ),
                                          value: Type.user,
                                          visualDensity: const VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
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
                                          visualDensity: const VisualDensity(
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                              vertical:
                                                  VisualDensity.minimumDensity),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60,
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
                              onTap: () {},
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
                              "มีบัญชีแล้ว ? ",
                              style: AppText.body,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.login);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.green,
                              ),
                              child: const Text("เข้าสู่ระบบ"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: AppColors.grey,
    );
  }
}
