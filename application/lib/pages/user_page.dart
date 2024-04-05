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
  final node = [
    const LatLng(18.795245857106156, 98.99009726127217), // 1
    const LatLng(18.795247526772357, 98.99018015585891), // 2
    const LatLng(18.79524293909769, 98.99025170284756), // 3
    const LatLng(18.795239744343995, 98.99033382070922), // 4
    const LatLng(18.795236549590225, 98.99045980975728), // 5
    const LatLng(18.795230823711357, 98.99061372066065), // 6
    const LatLng(18.795223846395654, 98.99077862257336), // 7
    const LatLng(18.795218180662566, 98.99088012827998), // 8
    const LatLng(18.79521419341057, 98.99106058235776), // 9
    const LatLng(18.795206917653218, 98.99114841758295), // 10
    const LatLng(18.795207672695195, 98.99121915551834), // 11
    const LatLng(18.79520338692916, 98.99130817243757), // 12
    const LatLng(18.7952016686964, 98.99140695144028), // 13
    const LatLng(18.795192395165444, 98.99149791322503), // 14
    const LatLng(18.795193719955602, 98.99168123620659), // 15
    const LatLng(18.795183121633926, 98.99181278093873), // 16
    const LatLng(18.795179147263276, 98.99203108921516), // 17
    const LatLng(18.795170162023233, 98.99222594158269), // 18
    const LatLng(18.795164392502393, 98.99248984425635), // 19
    const LatLng(18.79490088959547, 98.99245308019493), // 20
    const LatLng(18.794786432563804, 98.99243388513172), // 21
    const LatLng(18.794693883906398, 98.99241779991803), // 22
    const LatLng(18.7946403277011, 98.9924079244198), // 23
    const LatLng(18.794596159949887, 98.99239951618407), // 24
    const LatLng(18.794503891338472, 98.99238046278106), // 25
    const LatLng(18.7944185335181, 98.99236484407002), // 26
    const LatLng(18.794363629243623, 98.99235429923185), // 27
    const LatLng(18.794395573550954, 98.9919630857359), // 28
    const LatLng(18.794307784858123, 98.9923427744283), // 29
    const LatLng(18.79421256494263, 98.9923320455919), // 30
    const LatLng(18.794129743420644, 98.99231520781342), // 31
    const LatLng(18.79409931871579, 98.99231300728373), // 32
    const LatLng(18.793982657653974, 98.99229966500957), // 33
    const LatLng(18.79387596950167, 98.9922906163645), // 34
    const LatLng(18.793817563548103, 98.99228732594823), // 35
    const LatLng(18.79376305131004, 98.99228568074), // 36
    const LatLng(18.793674274198874, 98.9922766320948), // 37
    const LatLng(18.793581480277165, 98.99227237418143), // 38
    const LatLng(18.79362838470255, 98.99201492948984), // 39
    const LatLng(18.793508720327424, 98.99226125206988), // 40
    const LatLng(18.793405521715968, 98.99224847154122), // 41
    const LatLng(18.793440395736702, 98.99205526002042), // 42
    const LatLng(18.79331299876794, 98.99222366227986), // 43
    const LatLng(18.793224034347716, 98.99219659763104), // 44
    const LatLng(18.793189160280697, 98.992186824286), // 45
    const LatLng(18.793224034346252, 98.99204924565447), // 46
    const LatLng(18.793157878695702, 98.99217757445771), // 47
    const LatLng(18.793118027443878, 98.9921616110455), // 48
    const LatLng(18.793035617271652, 98.99212664076937), // 49
    const LatLng(18.792874059410487, 98.99211615354655), // 50
    const LatLng(18.79280530393715, 98.99211163117785), // 51
    const LatLng(18.79282315440053, 98.99201188970095), // 52
    const LatLng(18.79283236614528, 98.99193703984608), // 53
    const LatLng(18.792844412272686, 98.99184647152555), // 54
    const LatLng(18.792867795928647, 98.9917177297792), // 55
    const LatLng(18.792879842053786, 98.9916309039507), // 56
    const LatLng(18.792885510818223, 98.99156503608168), // 57
    const LatLng(18.79289684834597, 98.99149991670795), // 58
    const LatLng(18.79290251710999, 98.99143704283374), // 59
    const LatLng(18.792913854637035, 98.99134348051668), // 60
    const LatLng(18.792920231995698, 98.99127237315649), // 61
    const LatLng(18.79292731794954, 98.99120425979001), // 62
    const LatLng(18.792907802769236, 98.99107010242525), // 63
    const LatLng(18.79284178308554, 98.99106742021617), // 64
    const LatLng(18.792795124903677, 98.99104104442284), // 65
    const LatLng(18.7927862376348, 98.99098471803946), // 66
    const LatLng(18.792788776854714, 98.99087474746638), // 67
    const LatLng(18.792788865624654, 98.99074602487732), // 68
    const LatLng(18.792791737088084, 98.9906397817229), // 69
    const LatLng(18.792804433187865, 98.99006444788427), // 70
    const LatLng(18.79316944562621, 98.9900148270194), // 71
    const LatLng(18.79322261767118, 98.98999905115453), // 72
    const LatLng(18.793211826014073, 98.99012042111629), // 73
    const LatLng(18.793074036080945, 98.99106634284344), // 74
    const LatLng(18.793222950662955, 98.99105923203814), // 75
    const LatLng(18.793279561185443, 98.99100861733629), // 76
    const LatLng(18.793295020764536, 98.99072445844789), // 77
    const LatLng(18.79329720283252, 98.99061228414214), // 78
    const LatLng(18.793299384900543, 98.9905070246901), // 79
    const LatLng(18.793302294323915, 98.9904132899964), // 80
    const LatLng(18.793301566968616, 98.99032416520556), // 81
    const LatLng(18.793316114084572, 98.99020584435867), // 82
    const LatLng(18.793320018453336, 98.98996807203017), // 83
  ];

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
      1: {2: 785},
      2: {1: 785, 3: 608},
      3: {2: 608, 4: 919},
      4: {3: 919, 5: 1526},
      5: {4: 1526, 6: 1493},
      6: {5: 1493, 7: 2030},
      7: {6: 2030, 8: 797},
      8: {7: 797, 9: 1840},
      9: {8: 1840, 10: 1069},
      10: {9: 1069, 11: 705},
      11: {10: 705, 12: 893},
      12: {11: 893, 13: 915},
      13: {12: 915, 14: 761},
      14: {13: 761, 15: 1939},
      15: {14: 1939, 16: 1698},
      16: {15: 1698, 17: 2206},
      17: {16: 2206, 18: 2083},
      18: {17: 2083, 19: 2731},
      19: {18: 2731, 20: 2827},
      20: {19: 2827, 21: 1308},
      21: {20: 1308, 22: 1008},
      22: {21: 1008, 23: 594},
      23: {22: 594, 24: 613},
      24: {23: 613, 25: 889},
      25: {24: 889, 26: 980},
      26: {25: 980, 27: 655},
      27: {26: 655, 28: 4165, 29: 634},
      28: {27: 4165},
      29: {27: 634, 30: 1068},
      30: {29: 1068, 31: 883},
      31: {30: 883, 32: 401},
      32: {31: 401, 33: 1301},
      33: {32: 1301, 34: 1169},
      34: {33: 1169, 35: 662},
      35: {34: 662, 36: 540},
      36: {35: 540, 37: 949},
      37: {36: 949, 38: 1021},
      38: {37: 1021, 39: 2753, 40: 928},
      39: {38: 2753},
      40: {38: 928, 41: 1097},
      41: {40: 1097, 42: 2201, 43: 1012},
      42: {41: 2201},
      43: {41: 1012, 44: 982},
      44: {43: 982, 45: 588},
      45: {44: 588, 46: 1490, 47: 315},
      46: {45: 1490},
      47: {45: 315, 48: 579},
      48: {47: 579, 49: 915},
      49: {48: 915, 50: 1367},
      50: {49: 1367, 51: 1088},
      51: {50: 1088, 52:1237},
      52: {51: 1237, 53: 777},
      53: {52: 777, 54: 1147},
      54: {53: 1147, 55: 1333},
      55: {54: 1333, 56: 796},
      56: {55: 796, 57: 582},
      57: {56: 582, 58: 720},
      58: {57: 720, 59: 697},
      59: {58: 697, 60: 969},
      60: {59: 969, 61: 838},
      61: {60: 838, 62: 732},
      62: {61: 732, 63: 1418},
      63: {62: 1418, 64: 808, 73: 10300, 74: 1642},
      64: {63: 808, 65: 585},
      65: {64: 585, 66: 684},
      66: {65: 684, 67: 1393},
      67: {66: 1393, 68: 1275},
      68: {67: 1275, 69: 950},
      69: {68: 950, 70: 6092},
      70: {69: 6092, 71: 4053},
      71: {70: 4053, 72: 569},
      72: {71: 569, 73: 1267, 83: 1054},
      73: {72: 1267, 63: 10300},
      74: {63: 1642, 75: 1835},
      75: {74: 1835, 76: 1116},
      76: {75: 1116, 77: 2565},
      77: {76: 2565, 78: 1237},
      78: {77: 1237, 79: 1106},
      79: {78: 1106, 80: 1093},
      80: {79: 1093, 81: 885},
      81: {80: 885, 82: 1344},
      82: {81: 1344, 83: 2408},
      83: {72: 1054, 82: 2408},
    };
    int from = 39;
    int to = 73;
    output = Dijkstra.findPathFromGraph(graph, from, to);
    // ignore: avoid_print
    print(output);
  }

  drawPolylines() async {
    for (int i = 0; i < output.length - 1; i++) {
      polylines.add(Polyline(
        polylineId: const PolylineId("Shortest Path"),
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
