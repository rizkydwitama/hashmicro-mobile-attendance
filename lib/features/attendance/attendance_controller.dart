import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../models/location_model.dart';

class AttendanceController extends GetxController {
  final MapController mapController = MapController();
  List<LocationModel> locationList = <LocationModel>[].obs;
  RxDouble userLatitude = 0.1.obs;
  RxDouble userLongitude = 0.1.obs;
  var markers = <Marker>[].obs;
  var circles = <CircleMarker>[].obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool far = false.obs;

  String? locationName;

  @override
  void onInit() async {
    await getLocations();
    super.onInit();
  }

  Future<void> getLocations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .get();
      locationList = querySnapshot.docs
          .map((doc) => LocationModel.fromFirestore(doc))
          .toList();
      update();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch locations',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<Position> getUserPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Error',
        'Failed to fetch locations',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Error',
        'Failed to fetch locations',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        Get.snackbar(
          'Error',
          'Failed to fetch locations',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        );
      }
    }
    position = await Geolocator.getCurrentPosition();
    userLatitude.value = position.latitude;
    userLongitude.value = position.longitude;
    return position;
  }

  void getLocationValue(value) {
    for (var i in locationList) {
      if (i.name == value) {
        latitude.value = i.geopoint.latitude;
        longitude.value = i.geopoint.longitude;
        getLastPosition(latitude.value, longitude.value, 50, i.name);
      }
    }
  }

  void getLastPosition(endLat, endLng, radius, locName) async {
    Position? position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      double lat = position.latitude;
      double long = position.longitude;
      await getDistance(lat, long, endLat, endLng, radius, locName);
      mapController.move(LatLng(endLat, endLng), 18);
      print(endLat + endLng);
    }
  }

  Future getDistance(double strLat, double strLng, endLat, endLng, radius, locName) async {
    double distanceInMeters = Geolocator.distanceBetween(strLat, strLng, endLat, endLng);
    print(distanceInMeters);
      markers.clear();
      markers.add(
          Marker(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            point: LatLng(endLat,endLng),
            child: const Icon(
              Icons.location_on,
              size: 50,
              color: Colors.red,
            ),
          )
      );
      circles.clear();
      circles.add(
          CircleMarker(
              point: LatLng(endLat, endLng),
              radius: 50.0,
              color: Colors.pink[100]!.withOpacity(0.5),
              borderColor: Colors.pink,
              borderStrokeWidth: 1,
              useRadiusInMeter: true
          )
      );
    if (distanceInMeters.toInt() >= radius) {
      Get.snackbar(
        'Error',
        'You are out of range of $locName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      );
      far.value = true;
    } else {
      Get.snackbar(
        'Success',
        'You are in range',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: Icon(Icons.check, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: Duration(seconds: 3),
      );
      far.value = false;
    }
    update();
  }
  Future<void> sendAttendance({
    required String locationName,
  }) async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      CollectionReference attendances = FirebaseFirestore.instance.collection('attendances');
      await attendances.add({
        'location_name': locationName,
        'geopoint': GeoPoint(position.latitude, position.longitude), // Add geopoint here
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add server timestamp
      });
      if(far.value) {
        Get.snackbar(
          'Error',
          'You cannot attend because out of range',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Success',
          'Attendance successfully sent',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check, color: Colors.white),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          duration: Duration(seconds: 3),
        );
      }

    } catch (e) {
      debugPrint(e.toString());
    }
    update();
  }
}