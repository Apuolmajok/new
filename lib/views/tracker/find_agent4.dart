import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/tracker/map_route5.dart';

class LocatingPickupAgentPage extends StatefulWidget {
  const LocatingPickupAgentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocatingPickupAgentPageState createState() =>
      _LocatingPickupAgentPageState();
}

class _LocatingPickupAgentPageState extends State<LocatingPickupAgentPage> {
  // ignore: unused_field
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Location _location = Location();

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
      _simulateFindingAgent();
    });
  }

  void _updateMarkers() {
    _markers.clear();
    if (_currentLocation != null) {
      // Define the agent's location relative to the user's current location
      LatLng agentLocation = LatLng(
        _currentLocation!.latitude + 0.001, // Slightly adjust latitude
        _currentLocation!.longitude + 0.001, // Slightly adjust longitude
      );

      _markers.add(Marker(
        markerId: MarkerId('pickup_agent'),
        position: agentLocation, // Pickup agent location relative to user
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen), // Green marker
      ));
    }
  }

  void _simulateFindingAgent() async {
    // Simulate a delay for finding the agent
    await Future.delayed(Duration(seconds: 5));

    // Navigate to the next page when agent is found
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RoutePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locating Pickup Agent'),
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
                )
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration:const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Locating nearest pickup agent...',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: kPrimary,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary, // Green button
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 12.0),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
          _currentLocation != null
              ? Positioned(
                  top: MediaQuery.of(context).size.height * 0.4,
                  left: MediaQuery.of(context).size.width * 0.5 - 25,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class AgentFoundPage extends StatelessWidget {
  const AgentFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Found'),
        backgroundColor: kPrimary,
      ),
      body: const Center(
        child: Text(
          'Pickup agent has been found!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
