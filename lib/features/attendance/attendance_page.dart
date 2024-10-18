import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashmicro_mobile_attendance/features/attendance/attendance_controller.dart';
import 'package:hashmicro_mobile_attendance/widgets/dropdown_widget.dart';

import '../../widgets/flutter_map_widget.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttendanceController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Attendance'
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: DropdownWidget(
                    hintText: 'Please choose attendance location.',
                    selectedItem: controller.locationName,
                    itemList: controller.locationList
                        .map((location) => location.name).toList(),
                    onChanged: (String? value) {
                      controller.locationName = value;
                      controller.getLocationValue(value);
                      controller.update();
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  height: Get.height * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FlutterMapWidget(
                      mapController: controller.mapController,
                      onMapReady: () => controller.mapController.mapEventStream.listen((evt) {}),
                      markers: controller.markers.toList(),
                      circles: controller.circles.toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: Get.width,
                  height: Get.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.sendAttendance(
                        locationName: controller.locationName ?? '',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey, // Set the text color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      elevation: 5, // Optional: adds a shadow for depth effect
                    ),
                    child: const Text('Submit Attendance'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
