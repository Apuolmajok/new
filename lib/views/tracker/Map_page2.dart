import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; // Ensure this import is present
import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates; // Import geocoding package
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/tracker/address_details3.dart';

class GoogleMapsPage extends StatefulWidget {
  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  String? _currentAddress;
  final Set<Marker> _markers = {};
  final Location _locationService =
      Location(); // Initialize the Location object here

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    final permissionGranted = await _locationService.requestPermission();
    if (permissionGranted == PermissionStatus.granted) {
      final locationEnabled = await _locationService.serviceEnabled();
      if (!locationEnabled) {
        final serviceRequested = await _locationService.requestService();
        if (!serviceRequested) return;
      }
      _locationService.onLocationChanged.listen((locationData) {
        if (locationData.latitude != null && locationData.longitude != null) {
          setState(() {
            _currentLocation =
                LatLng(locationData.latitude!, locationData.longitude!);
            _markers.add(Marker(
              markerId: MarkerId('current_location'),
              position: _currentLocation!,
              infoWindow: InfoWindow(
                title: 'Your Location',
                snippet: 'Current location',
              ),
            ));
            _mapController
                .animateCamera(CameraUpdate.newLatLng(_currentLocation!));
            _updateAddress(_currentLocation!);
          });
        }
      });
    }
  }

  void _updateAddress(LatLng location) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      _mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Pickup Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation ?? LatLng(13.0072, 80.2273),
              zoom: 15.0,
            ),
            markers: _markers,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // Wrap with Expanded to prevent overflow
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentAddress ?? 'Fetching address...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _currentAddress ?? 'Fetching address...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle "Change" button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          child: Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddressDetailsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        minimumSize: Size(double.infinity, 30),
                      ),
                      child: const Text(
                        'Enter Complete Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
