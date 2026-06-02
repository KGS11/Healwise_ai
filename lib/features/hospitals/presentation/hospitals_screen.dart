import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../data/location_service.dart';
import '../data/places_service.dart';
import '../domain/hospital_model.dart';
import 'widgets/hospital_card.dart';
import 'widgets/hospital_map_view.dart';
import 'widgets/location_permission_card.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  final LocationService _locationService = const LocationService();
  late final PlacesService _placesService;
  final MapController _mapController = MapController();

  Position? _currentPosition;
  List<HospitalModel> _hospitals = [];
  bool _isLoading = true;
  bool _locationDenied = false;
  List<Marker> _markers = [];
  HospitalModel? _selectedHospital;
  int _searchRadius = 5000;

  @override
  void initState() {
    super.initState();
    _placesService = PlacesService();
    _initializeLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
      _locationDenied = false;
    });

    try {
      final hasPermission = await _locationService.requestPermission();
      if (!hasPermission) {
        setState(() {
          _locationDenied = true;
          _isLoading = false;
        });
        return;
      }

      final position = await _locationService.getCurrentPosition();
      _currentPosition = position;

      await _fetchHospitals(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(
        e is TimeoutException
            ? 'Location request timed out. Please try again.'
            : 'Failed to retrieve location. Please enable GPS.',
      );
    }
  }

  Future<void> _fetchHospitals(double lat, double lng) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await _placesService.getNearbyHospitals(
        latitude: lat,
        longitude: lng,
        radiusMeters: _searchRadius,
      );

      setState(() {
        _hospitals = list;
        _isLoading = false;
        _buildMarkers(lat, lng);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('quota') || errStr.contains('limit')) {
        _showErrorSnackBar('Search limit reached. Please try again later.');
      } else if (errStr.contains('socket') || errStr.contains('network')) {
        _showErrorSnackBar('No internet connection. Please check network.');
      } else {
        _showErrorSnackBar('Could not retrieve wellness centers.');
      }
    }
  }

  void _buildMarkers(double userLat, double userLng) {
    final List<Marker> tempMarkers = [];

    // User location marker (Azure HUE color style equivalent: blue dynamic icon)
    tempMarkers.add(
      Marker(
        point: LatLng(userLat, userLng),
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ),
      ),
    );

    // Wellness Center markers (Green icons)
    for (final hospital in _hospitals) {
      tempMarkers.add(
        Marker(
          point: LatLng(hospital.latitude, hospital.longitude),
          width: 45,
          height: 45,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedHospital = hospital;
              });
              _mapController.move(LatLng(hospital.latitude, hospital.longitude), 15.0);
            },
            child: const Icon(
              Icons.location_on,
              color: Colors.green,
              size: 38,
            ),
          ),
        ),
      );
    }

    setState(() {
      _markers = tempMarkers;
    });
  }

  Future<String?> _fetchPhoneNumber(String placeId) async {
    // OSM does not support Place details query, return null
    return null;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital_outlined,
              size: 72,
              color: primaryColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No naturopathy centers found nearby',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try increasing the search radius to discover wellness clinics.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchRadius = 10000;
                });
                if (_currentPosition != null) {
                  _fetchHospitals(_currentPosition!.latitude, _currentPosition!.longitude);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Search in 10km radius'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState() {
    final currentPos = _currentPosition!;
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.40,
          child: HospitalMapView(
            userLatitude: currentPos.latitude,
            userLongitude: currentPos.longitude,
            markers: _markers,
            mapController: _mapController,
            selectedLatLng: _selectedHospital != null
                ? LatLng(_selectedHospital!.latitude, _selectedHospital!.longitude)
                : null,
          ),
        ),
        Expanded(
          child: _hospitals.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _hospitals.length,
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemBuilder: (context, index) {
                    final hospital = _hospitals[index];
                    return HospitalCard(
                      hospital: hospital,
                      isSelected: _selectedHospital?.placeId == hospital.placeId,
                      onFetchPhoneNumber: _fetchPhoneNumber,
                      onTapCard: () {
                        setState(() {
                          _selectedHospital = hospital;
                          _mapController.move(LatLng(hospital.latitude, hospital.longitude), 15.0);
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nearby Wellness Centers',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Naturopathy & Ayurveda near you',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh location',
            onPressed: _initializeLocation,
          ),
        ],
      ),
      body: _locationDenied
          ? const LocationPermissionCard()
          : _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: primaryColor),
                      const SizedBox(height: 16),
                      const Text(
                        'Finding wellness centers near you...',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildLoadedState(),
    );
  }
}
