import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:application/config/map.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:application/config/config.dart';
import 'package:application/styles/app_text.dart';
import 'package:application/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum Type { none, male, female }

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
  late SharedPreferences prefs;

  bool selectEventType = true;
  bool selectEventForm = false;
  bool selectPosition = false;
  bool submitEvent = false;
  bool fireEvent = false;

  var sex = Type.none;
  bool eventValidate = false;
  bool sexValidate = false;
  bool ageValidate = false;
  bool symptomValidate = false;
  bool nameValidate = false;
  bool phoneValidate = false;

  TextEditingController eventController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final Completer<GoogleMapController> mapController = Completer();
  Location location = Location();
  LatLng lamChangCity = const LatLng(18.79399727691207, 98.9912201458245);
  LatLng? currentP;

  bool showCenterMarker = true;
  bool selectDestination = true;

  late Marker centerMarker;
  late LatLng destinationLatLng;
  late Marker destinationMarker;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void toggleVisibility(int section) {
    setState(() {
      selectEventType = section == 1;
      selectEventForm = section == 2;
      selectPosition = section == 3;
      submitEvent = section == 4;
    });
  }

  void submitEventForm() async {
    if (eventController.text.isEmpty) {
      setState(() {
        eventValidate = true;
      });
    } else {
      setState(() {
        eventValidate = false;
      });
    }

    if (sex == Type.none) {
      setState(() {
        sexValidate = true;
      });
    } else {
      setState(() {
        sexValidate = false;
      });
    }

    if (ageController.text.isEmpty) {
      setState(() {
        ageValidate = true;
      });
    } else {
      setState(() {
        ageValidate = false;
      });
    }

    if (symptomController.text.isEmpty) {
      setState(() {
        symptomValidate = true;
      });
    } else {
      setState(() {
        symptomValidate = false;
      });
    }

    if (nameController.text.isEmpty) {
      setState(() {
        nameValidate = true;
      });
    } else {
      setState(() {
        nameValidate = false;
      });
    }

    if (phoneController.text.isEmpty) {
      setState(() {
        phoneValidate = true;
      });
    } else {
      setState(() {
        phoneValidate = false;
      });
    }

    if (eventController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        symptomController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        sex != Type.none) {
      setState(() {
        toggleVisibility(3);
      });
    }
  }

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

  void contactOfficer() async {
    if (fireEvent == false) {
      String sexvalue = "";

      switch (sex) {
        case Type.male:
          sexvalue = "ชาย";
          break;
        case Type.female:
          sexvalue = "หญิง";
          break;
        default:
          sexvalue = "";
      }

      var eventBody = {
        "event": eventController.text,
        "sex": sexvalue,
        "age": ageController.text,
        "symptom": symptomController.text,
        "name": nameController.text,
        "phone": phoneController.text,
        "location": to,
      };

      var response = await http.post(Uri.parse(reportevent),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(eventBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        showCenterMarker = true;
        selectDestination = true;
        toggleVisibility(4);
      }
    } else {
      var eventBody = {
        "event": "เหตุเพลิงไหม้",
        "sex": "N/A",
        "age": "N/A",
        "symptom": "N/A",
        "name": "N/A",
        "phone": "N/A",
        "location": to,
      };

      var response = await http.post(Uri.parse(reportevent),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(eventBody));

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        showCenterMarker = true;
        selectDestination = true;
        toggleVisibility(4);
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
          backgroundColor: AppColors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.only(left: 15),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: selectPosition ? AppColors.white : AppColors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            actions: <Widget>[
              Visibility(
                visible: selectPosition,
                child: Container(
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
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: selectEventType,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'แจ้งเหตุฉุกเฉิน',
                            style: AppText.header2,
                          ),
                          const Text(
                            "กรุณาเลือกเหตุการณ์",
                            style: AppText.subtitle2,
                          ),
                          const SizedBox(
                            height: 175,
                          ),
                          Container(
                            height: 70,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.yellow,
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    toggleVisibility(2);
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: const Center(
                                  child: Text(
                                    "มีผู้บาดเจ็บ",
                                    style: AppText.button,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 70,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.red,
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    fireEvent = true;
                                    toggleVisibility(3);
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: const Center(
                                  child: Text(
                                    "เกิดเหตุเพลิงไหม้",
                                    style: AppText.button,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectEventForm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'ข้อมูลผู้บาดเจ็บ',
                            style: AppText.header2,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      controller: eventController,
                                      decoration: InputDecoration(
                                        hintText: "เหตุการณ์",
                                        hintStyle: AppText.body,
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: eventValidate
                                            ? "กรุณาป้อนเหตุการณ์"
                                            : null,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: RadioListTile(
                                                activeColor: AppColors.yellow,
                                                title: const Text(
                                                  "ชาย",
                                                  style: AppText.body,
                                                ),
                                                value: Type.male,
                                                visualDensity:
                                                    const VisualDensity(
                                                  horizontal: VisualDensity
                                                      .minimumDensity,
                                                  vertical: VisualDensity
                                                      .minimumDensity,
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                                groupValue: sex,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sex = Type.male;
                                                  });
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: RadioListTile(
                                                activeColor: AppColors.yellow,
                                                title: const Text(
                                                  "หญิง",
                                                  style: AppText.body,
                                                ),
                                                value: Type.female,
                                                visualDensity:
                                                    const VisualDensity(
                                                        horizontal:
                                                            VisualDensity
                                                                .minimumDensity,
                                                        vertical: VisualDensity
                                                            .minimumDensity),
                                                contentPadding: EdgeInsets.zero,
                                                groupValue: sex,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sex = Type.female;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        sexValidate
                                            ? const Text("กรุณาเลือกเพศ",
                                                style: AppText.error)
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      controller: ageController,
                                      decoration: InputDecoration(
                                        hintText: "อายุ",
                                        hintStyle: AppText.body,
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: ageValidate
                                            ? "กรุณาป้อนอายุ"
                                            : null,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      controller: symptomController,
                                      decoration: InputDecoration(
                                        hintText: "อาการ",
                                        hintStyle: AppText.body,
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: symptomValidate
                                            ? "กรุณาป้อนอาการ"
                                            : null,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        hintText: "ชื่อผู้แจ้งเหตุ",
                                        hintStyle: AppText.body,
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: nameValidate
                                            ? "กรุณาป้อนชื่อผู้แจ้งเหตุ"
                                            : null,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.underline,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: TextFormField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        hintText: "เบอร์ติดต่อผู้แจ้งเหตุ",
                                        hintStyle: AppText.body,
                                        border: InputBorder.none,
                                        errorStyle: const TextStyle(
                                            color: AppColors.red),
                                        errorText: phoneValidate
                                            ? "กรุณาป้อนเบอร์ติดต่อผู้แจ้งเหตุ"
                                            : null,
                                      ),
                                      style: const TextStyle(
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.red,
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  submitEventForm();
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: const Center(
                                  child: Text(
                                    "ยืนยันการแจ้งเหตุ",
                                    style: AppText.button,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectPosition,
                    child: currentP == null
                        ? const Center(
                            child: Text(
                              "Loading...",
                              style: TextStyle(
                                color: AppColors.green,
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: GoogleMap(
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    mapController.complete(controller);
                                  },
                                  mapType: MapType.hybrid,
                                  initialCameraPosition: CameraPosition(
                                    target: lamChangCity,
                                    zoom: 17.5,
                                  ),
                                  onCameraMove:
                                      (CameraPosition cameraPosition) {
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
                                ),
                              ),
                              Positioned(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.05,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      child: RawMaterialButton(
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
                                    ),
                                    Visibility(
                                      visible: selectDestination,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            showCenterMarker = false;
                                            selectDestination = false;
                                            findClosestEndNode(
                                                destinationLatLng);
                                            destinationMarker = Marker(
                                              markerId: const MarkerId(
                                                  "Your Destination"),
                                              position: inSideNode[to - 1],
                                              icon: BitmapDescriptor
                                                  .defaultMarkerWithHue(350),
                                            );
                                            destinationLatLng =
                                                inSideNode[to - 1];
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.yellow),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.018,
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.195,
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
                                          setState(() {
                                            contactOfficer();
                                          });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.green),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsetsGeometry>(
                                            EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.018,
                                              horizontal: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.191,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'ติดต่อเจ้าหน้าที่',
                                          style: AppText.button,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  Visibility(
                    visible: submitEvent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "แจ้งเหตุสำเร็จ",
                            style: AppText.header2,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "เจ้าหน้าที่กำลังเดินทางไปกรุณารอสักครู่",
                            style: AppText.subtitle2,
                          ),
                          const SizedBox(
                            height: 175,
                          ),
                          Container(
                            height: 70,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.red,
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    toggleVisibility(1);
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                child: const Center(
                                  child: Text(
                                    "กลับสู่หน้าแรก",
                                    style: AppText.button,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
