import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  static const LatLng lamChangCity =
      LatLng(18.793739574625956, 98.9917824807691);
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: const CameraPosition(
        target: lamChangCity,
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    ));
  }
}
