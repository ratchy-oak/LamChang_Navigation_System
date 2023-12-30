import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const HomePage({super.key, this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String username;
  late String type;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    username = jwtDecodedToken['username'];
    type = jwtDecodedToken['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(username), Text(type)],
        ),
      ),
    );
  }
}
