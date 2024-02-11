import 'dart:async';
import 'package:application/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  static const LatLng lamChangCity = LatLng(18.793585, 98.991854);
  final Completer<GoogleMapController> mapController = Completer();
  Location location = Location();
  LatLng? currentP;

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          // ignore: avoid_print
          print(currentP);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text(titleName),
      ),
      body: currentP == null
          ? const Center(
              child: Text("Loading.."),
            )
          : GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                target: lamChangCity,
                zoom: 17,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId("Lamchang City"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: lamChangCity,
                ),
                Marker(
                  markerId: const MarkerId("Current Location"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentP!,
                ),
              },
            ),
    );
  }
}
