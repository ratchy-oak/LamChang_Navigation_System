import 'package:application/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:application/styles/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const LoginPage(),
    );
  }
}
