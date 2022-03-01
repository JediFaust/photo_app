import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_app/src/models/photo_location.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key, @required this.selectedLocation}) : super(key: key);

  PhotoLocation? selectedLocation;

  static double? latitude;
  static double? longitude;

  static const String routeName = '/location';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static final Marker _kGooglePlexMarker = Marker(
      markerId: const MarkerId('Photo Location'),
      infoWindow: const InfoWindow(title: 'Location The Photo was taken'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(
          MapScreen.latitude ?? 37.773972, MapScreen.longitude ?? -122.431297));

  @override
  void initState() {
    MapScreen.latitude = widget.selectedLocation!.latitude ?? 37.773972;
    MapScreen.longitude = widget.selectedLocation!.longitude ?? -122.431297;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        markers: {_kGooglePlexMarker},
        initialCameraPosition: CameraPosition(
          target: LatLng(MapScreen.latitude ?? 37.773972,
              MapScreen.longitude ?? -122.431297),
          zoom: 11.5,
        ),
      ),
    );
  }
}
