import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:application/config/map.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:application/styles/app_text.dart';
import 'package:application/styles/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelperPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const HelperPage({super.key, this.token});

  @override
  State<HelperPage> createState() => _HelperPageState();
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

class _HelperPageState extends State<HelperPage> {
  late String username;
  late String type;
  late String titleName;

  bool selectVehicle = true;
  bool selectDestination = true;
  bool showCenterMarker = true;

  final Completer<GoogleMapController> mapController = Completer();
  Location location = Location();
  LatLng lamChangCity = const LatLng(18.79399727691207, 98.9912201458245);
  LatLng? currentP;

  late Marker centerMarker;
  late LatLng destinationLatLng;
  late Marker destinationMarker;

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

    centerMarker = Marker(
      markerId: const MarkerId("Choose Destination"),
      position: lamChangCity,
      icon: BitmapDescriptor.defaultMarkerWithHue(350),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                  selectedIndex = -1;
                  inSidePolylines.clear();
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
          body: Stack(
            children: [
              currentP == null
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
                      initialCameraPosition: CameraPosition(
                        target: lamChangCity,
                        zoom: 17.5,
                      ),
                      onCameraMove: (CameraPosition cameraPosition) {
                        setState(() {
                          destinationLatLng = cameraPosition.target;
                          centerMarker = centerMarker.copyWith(
                            positionParam: cameraPosition.target,
                          );
                        });
                      },
                      markers: showCenterMarker
                          ? {centerMarker}
                          : {destinationMarker},
                      polylines: inSidePolylines,
                    ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0,
                left: MediaQuery.of(context).size.width * 0,
                right: MediaQuery.of(context).size.width * 0,
                child: Visibility(
                  visible: selectVehicle,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.skin,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    child: const Column(
                      children: [
                        Text(
                          'กรุณาเลือกพาหนะ',
                          style: AppText.warning,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.072,
                left: MediaQuery.of(context).size.width * 0.255,
                right: MediaQuery.of(context).size.width * 0.255,
                child: Visibility(
                  visible: selectDestination,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.skin,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.017),
                    child: const Column(
                      children: [
                        Text(
                          'กรุณาเลือกจุดหมาย',
                          style: AppText.warning,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            height: 215,
            color: AppColors.white,
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
                                      selectVehicle = false;
                                      // ignore: avoid_print
                                      print(
                                          "Your vehicle is: Fire Fighting Vehicle");
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
                                      selectVehicle = false;
                                      // ignore: avoid_print
                                      print(
                                          "Your vehicle is: Ambulance Vehicle");
                                    });
                                  },
                                  imagePath: 'assets/images/ambulance.jpg',
                                ),
                                BuildImage(
                                  index: 2,
                                  isSelected: selectedIndex == 2,
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 2;
                                      selectVehicle = false;
                                      // ignore: avoid_print
                                      print("Your vehicle is: Police Car");
                                    });
                                  },
                                  imagePath: 'assets/images/police.jpg',
                                ),
                                BuildImage(
                                  index: 3,
                                  isSelected: selectedIndex == 3,
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 3;
                                      selectVehicle = false;
                                      // ignore: avoid_print
                                      print(
                                          "Your vehicle is: Police Motorbike");
                                    });
                                  },
                                  imagePath: 'assets/images/motorbike.jpg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                        Icons.location_searching_rounded,
                      ),
                    ),
                    Visibility(
                      visible: selectDestination,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectDestination = false;
                            showCenterMarker = false;
                            findClosestStartNode(currentP);
                            findClosestEndNode(destinationLatLng);
                            destinationMarker = Marker(
                              markerId: const MarkerId("Your Destination"),
                              position: inSideNode[to - 1],
                              icon: BitmapDescriptor.defaultMarkerWithHue(350),
                            );
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColors.yellow),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.018,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.195,
                            ),
                          ),
                        ),
                        child: const Text(
                          'ยืนยันจุดหมาย',
                          style: AppText.button,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !selectDestination,
                      child: TextButton(
                        onPressed: () {
                          if (!selectVehicle) {
                            goToLamChangCity();
                            setState(() {
                              inSidePolylines.clear();
                              findShortestPath();
                              drawPolylines();
                            });
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(AppColors.green),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.018,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.232,
                            ),
                          ),
                        ),
                        child: const Text(
                          'หาเส้นทาง',
                          style: AppText.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.072,
          left: MediaQuery.of(context).size.width * 0.255,
          right: MediaQuery.of(context).size.width * 0.255,
          child: Visibility(
            visible: !selectDestination,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.017,
                ),
              ),
              onPressed: () {
                setState(() {
                  showCenterMarker = true;
                  selectDestination = true;
                  inSidePolylines.clear();
                });
              },
              child: const Text(
                'เปลี่ยนจุดหมาย',
                style: AppText.button2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
