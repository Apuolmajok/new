import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sharecare/constants/constants.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Location _location = Location();
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return; // Location service is not enabled
      }
    }

    // Check location permission
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return; // Location permission is not granted
      }
    }

    // Get current location
    LocationData locationData = await _location.getLocation();
    setState(() {
      _currentLocation =
          LatLng(locationData.latitude!, locationData.longitude!);
      _updateMarkers();
      _updateRoute();
    });
  }

  void _updateMarkers() {
    _markers.clear();
    if (_currentLocation != null) {
      // Define the agent's location relative to the user's current location
      LatLng agentLocation = LatLng(
        _currentLocation!.latitude! + 0.001, // Slightly adjust latitude
        _currentLocation!.longitude! + 0.001, // Slightly adjust longitude
      );

      _markers.add(Marker(
        markerId: MarkerId('pickup_agent'),
        position: agentLocation, // Pickup agent location relative to user
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.defaultMarker as double), // Green marker
      ));
    }
  }

  void _updateRoute() {
    _routePoints.clear();
    if (_currentLocation != null) {
      _routePoints.add(_currentLocation!);
      _routePoints.add(LatLng(
        _currentLocation!.latitude + 0.001, // Slightly adjust latitude
        _currentLocation!.longitude + 0.001, // Slightly adjust longitude
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kPrimary, // Green background
      ),
      body: Stack(
        children: [
          _currentLocation != null
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 15.0, // Adjust zoom level as needed
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _markers,
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      points: _routePoints,
                      color: kPrimary,
                      width: 5,
                    ),
                  },
                )
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary, // Green button
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16.0),
              ),
              child: const Text('Cancel'),
            ),
          ),
          Positioned(
            bottom: 80.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/agent_photo.jpg'), // Replace with actual image
                        radius: 30.0,
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rupesh Kumar',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: kPrimary,
                            ),
                          ),
                          const Text(
                            'Your Delivery Agent',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: kPrimary,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.green,
                                size: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Pickup Agent is on the way\nArriving at pickup point in 2 mins',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: kPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
