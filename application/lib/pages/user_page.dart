import 'package:application/styles/app_colors.dart';
import 'package:application/styles/app_text.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Type { none, male, female }

class UserPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const UserPage({super.key, this.token});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String username;
  late String type;
  late String titleName;
  late SharedPreferences prefs;
  bool selectEventType = true;
  bool eventValidate = false;
  TextEditingController eventController = TextEditingController();
  bool symptomValidate = false;
  TextEditingController symptomController = TextEditingController();
  bool nameValidate = false;
  TextEditingController nameController = TextEditingController();
  bool phoneValidate = false;
  TextEditingController phoneController = TextEditingController();
  bool ageValidate = false;
  TextEditingController ageController = TextEditingController();
  bool sexValidate = false;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    username = jwtDecodedToken['username'];
    type = jwtDecodedToken['type'];
    if (type == "user") {
      type = "ผู้ใช้งาน ";
    } else {
      type = "เจ้าหน้าที่ ";
    }
    titleName = type + username;
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void submitEvent() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Visibility(
              visible: selectEventType,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'แจ้งเหตุฉุกเฉิน',
                      style: AppText.header2,
                    ),
                    const Text(
                      "กรุณาเลือกเหตุการณ์",
                      style: AppText.subtitle2,
                    ),
                    const SizedBox(
                      height: 75,
                    ),
                    Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 50,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.yellow,
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectEventType = false;
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: const Center(
                            child: Text(
                              "มีผู้บาดเจ็บ",
                              style: AppText.button,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 70,
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
                              "เกิดเหตุเพลิงไหม้",
                              style: AppText.button,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !selectEventType,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'ข้อมูลผู้บาดเจ็บ',
                      style: AppText.header2,
                    ),
                    const SizedBox(
                      height: 35,
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: eventController,
                                decoration: InputDecoration(
                                  hintText: "เหตุการณ์",
                                  hintStyle: AppText.body,
                                  border: InputBorder.none,
                                  errorStyle:
                                      const TextStyle(color: AppColors.red),
                                  errorText: eventValidate
                                      ? "กรุณาป้อนเหตุการณ์"
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: AppColors.yellow,
                                          title: const Text(
                                            "ชาย",
                                            style: AppText.body,
                                          ),
                                          value: Type.male,
                                          visualDensity: const VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          groupValue: type,
                                          onChanged: (value) {},
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                          activeColor: AppColors.yellow,
                                          title: const Text(
                                            "หญิง",
                                            style: AppText.body,
                                          ),
                                          value: Type.female,
                                          visualDensity: const VisualDensity(
                                              horizontal:
                                                  VisualDensity.minimumDensity,
                                              vertical:
                                                  VisualDensity.minimumDensity),
                                          contentPadding: EdgeInsets.zero,
                                          groupValue: type,
                                          onChanged: (value) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  sexValidate
                                      ? const Text("กรุณาเลือกเพศ",
                                          style: AppText.error)
                                      : const SizedBox(),
                                ],
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: ageController,
                                decoration: InputDecoration(
                                  hintText: "อายุ",
                                  hintStyle: AppText.body,
                                  border: InputBorder.none,
                                  errorStyle:
                                      const TextStyle(color: AppColors.red),
                                  errorText:
                                      ageValidate ? "กรุณาป้อนอายุ" : null,
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: symptomController,
                                decoration: InputDecoration(
                                  hintText: "อาการ",
                                  hintStyle: AppText.body,
                                  border: InputBorder.none,
                                  errorStyle:
                                      const TextStyle(color: AppColors.red),
                                  errorText:
                                      symptomValidate ? "กรุณาป้อนอาการ" : null,
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
                      height: 30,
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: "ชื่อผู้แจ้งเหตุ",
                                  hintStyle: AppText.body,
                                  border: InputBorder.none,
                                  errorStyle:
                                      const TextStyle(color: AppColors.red),
                                  errorText: nameValidate
                                      ? "กรุณาป้อนชื่อผู้แจ้งเหตุ"
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: phoneController,
                                decoration: InputDecoration(
                                  hintText: "เบอร์ติดต่อผู้แจ้งเหตุ",
                                  hintStyle: AppText.body,
                                  border: InputBorder.none,
                                  errorStyle:
                                      const TextStyle(color: AppColors.red),
                                  errorText: phoneValidate
                                      ? "กรุณาป้อนเบอร์ติดต่อผู้แจ้งเหตุ"
                                      : null,
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
                            submitEvent();
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          child: const Center(
                            child: Text(
                              "ยืนยันการแจ้งเหตุ",
                              style: AppText.button,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
