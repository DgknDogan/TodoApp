import 'dart:ui';

import '../../auth/models/user_model.dart';
import '../data/profile_local_data.dart';

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData({
    required this.x,
    required this.y,
    required this.color,
  });

  static Future<List<ChartData>> initChartData() async {
    final localCache = LocalProfileCache();
    final UserModel currentUser = await localCache.getDataFromFirebase();
    const Color redColor = Color(0xffEF3726);
    const Color greenColor = Color(0xff00D23C);

    final data = [
      ChartData(
        x: 'Phone Number',
        y: 1,
        color: currentUser.phoneNumber == null ? redColor : greenColor,
      ),
      ChartData(
        x: 'Name',
        y: 1,
        color: currentUser.name == null ? redColor : greenColor,
      ),
      ChartData(
        x: 'Surname',
        y: 1,
        color: currentUser.surname == null ? redColor : greenColor,
      ),
    ];

    return data;
  }
}
