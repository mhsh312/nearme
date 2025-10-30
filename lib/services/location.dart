import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentUserLocation() async {
    // 1. Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return an error or throw an exception
      return Future.error('Location services are disabled.');
    }

    // 2. Check for location permissions
    LocationPermission permission = await Geolocator.checkPermission();

    // If permission is denied, request it
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission is still denied after the request
        return Future.error('Location permissions are permanently denied.');
      }
    }

    // If permission is denied forever, handle it
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied. We cannot request permissions.',
      );
    }

    // 3. Permissions are granted, now get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low, // Get coarse location
    );
  }
}
