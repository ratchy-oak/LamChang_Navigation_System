import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HelperPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const HelperPage({super.key, this.token});

  @override
  State<HelperPage> createState() => _HelperPageState();
}

class _HelperPageState extends State<HelperPage> {
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
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Helper Page")],
        ),
      ),
    );
  }
}
