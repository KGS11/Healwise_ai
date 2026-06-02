import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../domain/hospital_model.dart';

class PlacesService {
  final http.Client _client;

  PlacesService({http.Client? client}) : _client = client ?? http.Client();

  // Search nearby wellness, naturopathy, and ayurveda centers using OSM Nominatim Search API
  Future<List<HospitalModel>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    int radiusMeters = 5000,
  }) async {
    // OpenStreetMap Nominatim Search Endpoint
    // We prioritize clinics, naturopathy, ayurveda, and wellness centers near the user coordinates
    final url = 'https://nominatim.openstreetmap.org/search'
        '?q=naturopathy+wellness+ayurveda+hospital'
        '&format=json'
        '&lat=$latitude'
        '&lon=$longitude'
        '&limit=30';

    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'HealWiseAI/1.0 (com.example.healwise_ai)',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('OpenStreetMap API error: Status ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(response.body);
      final List<HospitalModel> hospitals = [];

      for (final item in data) {
        final double hLat = double.tryParse(item['lat']?.toString() ?? '') ?? 0.0;
        final double hLng = double.tryParse(item['lon']?.toString() ?? '') ?? 0.0;
        if (hLat == 0.0 && hLng == 0.0) continue;

        // Calculate distance in kilometers
        final double distance = Geolocator.distanceBetween(
          latitude,
          longitude,
          hLat,
          hLng,
        ) / 1000.0;

        // Nominatim returns a full comma-separated address as 'display_name'
        // We split it to extract a readable hospital name and address
        final String displayName = item['display_name'] as String? ?? '';
        final List<String> addressParts = displayName.split(',');
        final String name = addressParts.isNotEmpty ? addressParts.first.trim() : 'Wellness Center';
        final String address = addressParts.length > 1
            ? addressParts.sublist(1).join(',').trim()
            : displayName;

        final typeStr = item['type']?.toString() ?? 'wellness';

        hospitals.add(
          HospitalModel(
            placeId: (item['place_id'] ?? item['osm_id'])?.toString() ?? '',
            name: name,
            address: address,
            latitude: hLat,
            longitude: hLng,
            rating: null, // OpenStreetMap does not have standard rating attributes
            userRatingsTotal: null,
            isOpenNow: true, // Default to true for display
            phoneNumber: null, // Nominatim does not directly expose telephone info
            distanceKm: distance,
            types: [typeStr],
          ),
        );
      }

      // Sort by distance ascending
      hospitals.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

      // Return top 15 results
      return hospitals.take(15).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Details endpoint (no-op since OSM search doesn't require detail fetching)
  Future<String?> getPhoneNumber(String placeId) async {
    return null;
  }
}
