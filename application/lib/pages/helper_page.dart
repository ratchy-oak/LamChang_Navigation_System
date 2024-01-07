import 'dart:async';
import 'package:application/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  late String titleName;

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

  static const LatLng lamChangCity =
      LatLng(18.793739574625956, 98.9917824807691);
  final Completer<GoogleMapController> _controller = Completer();
  late LocationData currentLocation;

  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = (await getCurrentLocation())!;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
      zoom: 17,
    )));
  }

  Future _goToLamChangCity() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = (await getCurrentLocation())!;
    controller.animateCamera(CameraUpdate.newLatLng(lamChangCity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text(titleName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.maps_home_work_rounded),
            onPressed: _goToLamChangCity,
          )
        ],
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: const CameraPosition(
          target: lamChangCity,
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.red,
        foregroundColor: AppColors.white,
        onPressed: _goToMe,
        label: const Text('ตำแหน่งของฉัน'),
        icon: const Icon(Icons.near_me),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
