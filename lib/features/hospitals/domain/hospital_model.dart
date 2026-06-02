class HospitalModel {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? rating;
  final int? userRatingsTotal;
  final bool isOpenNow;
  final String? phoneNumber;
  final double distanceKm;
  final List<String> types;

  const HospitalModel({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.userRatingsTotal,
    required this.isOpenNow,
    this.phoneNumber,
    required this.distanceKm,
    required this.types,
  });

  factory HospitalModel.fromPlacesJson(
    Map<String, dynamic> json, {
    required double userLat,
    required double userLng,
    double calculatedDistance = 0.0,
  }) {
    final geometry = json['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    final lat = (location?['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (location?['lng'] as num?)?.toDouble() ?? 0.0;

    final openingHours = json['opening_hours'] as Map<String, dynamic>?;
    final openNow = openingHours?['open_now'] as bool? ?? false;

    final ratingVal = json['rating'] as num?;
    final userRatingsTotalVal = json['user_ratings_total'] as num?;

    final typesList = (json['types'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return HospitalModel(
      placeId: json['place_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: (json['vicinity'] ?? json['formatted_address']) as String? ?? '',
      latitude: lat,
      longitude: lng,
      rating: ratingVal?.toDouble(),
      userRatingsTotal: userRatingsTotalVal?.toInt(),
      isOpenNow: openNow,
      phoneNumber: json['formatted_phone_number'] as String?,
      distanceKm: calculatedDistance,
      types: typesList,
    );
  }

  HospitalModel copyWith({
    String? phoneNumber,
    double? distanceKm,
  }) {
    return HospitalModel(
      placeId: placeId,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      rating: rating,
      userRatingsTotal: userRatingsTotal,
      isOpenNow: isOpenNow,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      distanceKm: distanceKm ?? this.distanceKm,
      types: types,
    );
  }
}
