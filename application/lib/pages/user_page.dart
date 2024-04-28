import 'dart:async';
import 'package:application/config/config.dart';
import 'package:application/config/map.dart';
import 'package:application/styles/app_colors.dart';
import 'package:application/styles/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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

class BuildImage extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final String imagePath;

  const BuildImage({
    super.key,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ColorFiltered(
          colorFilter: isSelected
              ? const ColorFilter.mode(
                  AppColors.transparent, BlendMode.multiply)
              : const ColorFilter.mode(AppColors.grey, BlendMode.saturation),
          child: Image.asset(
            imagePath,
          ),
        ),
      ),
    );
  }
}

class _UserPageState extends State<UserPage> {
  late String username;
  late String type;
  late String titleName;
  static const LatLng lamChangCity =
      LatLng(18.79399727691207, 98.9912201458245);
  final Completer<GoogleMapController> mapController = Completer();
  Location location = Location();
  int selectedIndex = -1;
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
        });
      }
    });
  }

  Future<void> cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 17.5,
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

  List<LatLng> outSideNode = [];
  Map<PolylineId, Polyline> outSidePolylines = {};
  void findNormalPath() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(currentP!.latitude, currentP!.longitude),
      PointLatLng(inSideNode[output[0] - 1].latitude,
          inSideNode[output[0] - 1].longitude),
    );

    if (result.points.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      result.points.forEach(
        (PointLatLng point) => outSideNode.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.maps_home_work_rounded),
              color: AppColors.green,
              onPressed: goToLamChangCity,
            ),
          ),
        ],
      ),
      body: currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                target: lamChangCity,
                zoom: 17.5,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("Normal Path"),
                  points: outSideNode,
                  color: AppColors.yellow,
                  width: 7,
                ),
                Polyline(
                  polylineId: const PolylineId("Shortest Path"),
                  points: inSideNode,
                  color: AppColors.yellow,
                  width: 7,
                ),
              },
              markers: {
                if (to > 0)
                  Marker(
                    markerId: const MarkerId("Destination"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: inSideNode[to - 1],
                  ),
              },
            ),
      bottomNavigationBar: BottomAppBar(
        height: 205,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            BuildImage(
                              index: 0,
                              isSelected: selectedIndex == 0,
                              onTap: () {
                                setState(() {
                                  selectedIndex = 0;
                                  // ignore: avoid_print
                                  print("Fire Fighting Vehicle");
                                });
                              },
                              imagePath: 'assets/images/fire.jpg',
                            ),
                            BuildImage(
                              index: 1,
                              isSelected: selectedIndex == 1,
                              onTap: () {
                                setState(() {
                                  selectedIndex = 1;
                                  // ignore: avoid_print
                                  print("Ambulance Vehicle");
                                });
                              },
                              imagePath: 'assets/images/ambulance.webp',
                            ),
                            BuildImage(
                              index: 2,
                              isSelected: selectedIndex == 2,
                              onTap: () {
                                setState(() {
                                  selectedIndex = 2;
                                  // ignore: avoid_print
                                  print("Police Motorbike");
                                });
                              },
                              imagePath: 'assets/images/motorbike.png',
                            ),
                            BuildImage(
                              index: 3,
                              isSelected: selectedIndex == 3,
                              onTap: () {
                                setState(() {
                                  selectedIndex = 3;
                                  // ignore: avoid_print
                                  print("Police Car");
                                });
                              },
                              imagePath: 'assets/images/police.png',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1,
                    color: AppColors.grey,
                    thickness: 1,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    goToMe();
                  },
                  fillColor: AppColors.red,
                  padding: const EdgeInsets.all(15),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.near_me,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    goToLamChangCity();
                    setState(() {
                      from = 6;
                      to = 58;
                      findShortestPath();
                      findNormalPath();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 95),
                    ),
                  ),
                  child: const Text(
                    'หาเส้นทาง',
                    style: AppText.button,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
