import 'dart:async';
import 'package:application/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:dijkstra/dijkstra.dart';

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
  static const LatLng lamChangCity =
      LatLng(18.79399727691207, 98.9912201458245);
  final Completer<GoogleMapController> mapController = Completer();
  Location location = Location();
  LatLng? currentP;
  Set<Polyline> polylines = {};
  var output = [];

  // NODE LIST
  final node = [
    const LatLng(18.792803917221086, 98.99007145163777),
    const LatLng(18.793206885962203, 98.99002746865207),
  ];
  // NODE LIST

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
          print(currentP!);
        });
      }
    });
  }

  Future<void> cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 17,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCameraPosition),
    );
  }

  Future goToLamChangCity() async {
    cameraToPosition(lamChangCity);
  }

  Future goToMe() async {
    cameraToPosition(currentP!);
  }

  Future findShortestPath() async {
    Map graph = {
      1: {2: 4224, 3: 10400},
      2: {1: 4224, 4: 10613, 5: 1153},
      3: {1: 10400, 4: 1372},
      4: {2: 10613, 3: 1372, 6: 3793},
      5: {2: 1153, 6: 11177},
      6: {4: 3793, 5: 11177}
    };

    int from = 1;
    int to = 2;
    output = Dijkstra.findPathFromGraph(graph, from, to);
    // ignore: avoid_print
    print(output);
  }

  drawPolylines() async {
    for (int i = 0; i < output.length; i++) {
      if (i < (output.length - 1)) {
        polylines.add(Polyline(
          polylineId: const PolylineId(""),
          visible: true,
          width: 5, //width of polyline
          points: [
            node[output[i] - 1], //start point
            node[output[i + 1] - 1], //end point
          ],
          color: AppColors.yellow, //color of polyline
        ));
      }
    }
  }

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

    getLocationUpdates();
    findShortestPath();
    drawPolylines();
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
            onPressed: goToLamChangCity,
          )
        ],
      ),
      body: currentP == null
          ? const Center(
              child: Text("Loading.."),
            )
          : GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: ((GoogleMapController controller) =>
                  mapController.complete(controller)),
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                target: lamChangCity,
                zoom: 17,
              ),
              // markers: {
              //   const Marker(
              //     markerId: MarkerId("lamChangCity"),
              //     icon: BitmapDescriptor.defaultMarker,
              //     position: lamChangCity,
              //   ),
              // },
              polylines: polylines,
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.red,
        foregroundColor: AppColors.white,
        onPressed: goToMe,
        label: const Text('ตำแหน่งของฉัน'),
        icon: const Icon(Icons.near_me),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
