import 'package:application/pages/helper_page.dart';
import 'package:application/pages/login_page.dart';
import 'package:application/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:application/styles/app_colors.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Kanit",
          scaffoldBackgroundColor: AppColors.green,
          brightness: Brightness.dark,
          unselectedWidgetColor: AppColors.yellow,
        ),
        home: (JwtDecoder.isExpired(token) == false)
            ? UserPage(token: token)
            : const LoginPage());
  }
}
