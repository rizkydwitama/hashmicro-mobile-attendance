import 'package:get/get.dart';
import 'package:hashmicro_mobile_attendance/routes/page_name.dart';
import '../features/attendance/attendance_binding.dart';
import '../features/attendance/attendance_page.dart';

class PageRoutes {
  static final page = [
    GetPage(
        name: PageName.ATTENDANCE,
        binding: AttendanceBinding(),
        page: () => const AttendancePage()
    )
  ];
}