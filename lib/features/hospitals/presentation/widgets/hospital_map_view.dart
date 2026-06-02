import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HospitalMapView extends StatefulWidget {
  const HospitalMapView({
    super.key,
    required this.userLatitude,
    required this.userLongitude,
    required this.markers,
    required this.mapController,
    this.selectedLatLng,
  });

  final double userLatitude;
  final double userLongitude;
  final List<Marker> markers;
  final MapController mapController;
  final LatLng? selectedLatLng;

  @override
  State<HospitalMapView> createState() => _HospitalMapViewState();
}

class _HospitalMapViewState extends State<HospitalMapView> {
  @override
  void didUpdateWidget(covariant HospitalMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedLatLng != null && widget.selectedLatLng != oldWidget.selectedLatLng) {
      widget.mapController.move(widget.selectedLatLng!, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.userLatitude, widget.userLongitude),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.healwise_ai',
        ),
        MarkerLayer(
          markers: widget.markers,
        ),
      ],
    );
  }
}
