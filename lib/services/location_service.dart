// lib/services/location_service.dart

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could show a rationale
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue
    return true;
  }

  // Gets the current position and its human-readable address
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      final permissionGranted = await _handlePermission();
      if (!permissionGranted) {
        throw Exception('Location permission not granted.');
      }

      // Get the actual position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Convert coordinates to address (Reverse Geocoding)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      String address = '${place.street}, ${place.subLocality}, ${place.locality}';

      return {
        'latLng': LatLng(position.latitude, position.longitude),
        'address': address,
      };
    } catch (e) {
      // Log the error and return a fallback
      print('Location Error: $e');
      return {
        'latLng': const LatLng(23.7788, 86.4382), // Default Dhanbad Location (Fallback)
        'address': 'Dhanbad, Jharkhand (Fallback)',
      };
    }
  }
}