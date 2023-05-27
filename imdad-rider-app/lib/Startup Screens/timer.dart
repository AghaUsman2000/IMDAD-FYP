import 'dart:async';
import '../All Orders Screens/post_details_screen.dart';

class TimerClass {
  Timer? _timer;

  void startLocationUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      updateLocation();
    });
  }

  void stopLocationUpdates() {
    _timer?.cancel();
  }
}
