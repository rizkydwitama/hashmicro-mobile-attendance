import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class FlutterMapWidget extends StatelessWidget {
  const FlutterMapWidget({super.key, required this.mapController, this.onMapReady, required this.markers, required this.circles});
  final MapController mapController;
  final List<Marker> markers;
  final List<CircleMarker> circles;
  final Function()? onMapReady;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialZoom: 18,
        initialCenter: const LatLng(-6.1705787936630765, 106.8134198679617),
        onMapReady: onMapReady,
        keepAlive: true,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        CurrentLocationLayer(),
        CircleLayer(circles: circles),
        MarkerLayer(markers: markers),
      ],
    );
  }
}

