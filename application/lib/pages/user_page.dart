import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
          children: [Text("User Page")],
        ),
      ),
    );
  }
}
