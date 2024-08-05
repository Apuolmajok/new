import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; // Ensure this import is present
import 'package:geocoding/geocoding.dart'
    show Placemark, placemarkFromCoordinates; // Import geocoding package
import 'package:sharecare/constants/constants.dart';
import 'package:sharecare/views/tracker/find_agent4.dart';

class AddressDetailsPage extends StatefulWidget {
  const AddressDetailsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddressDetailsPageState createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  String? _currentAddress;
  final Set<Marker> _markers = {};
  final Location _locationService =
      Location(); // Initialize the Location object here

  // Variable to keep track of selected chip
  String _selectedChip = 'Home';

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
        title: const Text('Add Address Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height:
                  MediaQuery.of(context).size.height * 0.3, // Adjusted height
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentLocation ?? LatLng(13.0072, 80.2273),
                  zoom: 15.0,
                ),
                markers: _markers,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentAddress ?? 'Fetching address...',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                            SizedBox(height: 4),
                            Text(
                              _currentAddress ?? 'Fetching address...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Handle "Change" button press
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  SizedBox(height: 9),
                  _buildTextField('Plot no'),
                  SizedBox(height: 9),
                  _buildTextField('Floor no.'),
                  SizedBox(height: 9),
                  _buildTextField('Name of building, apartments'),
                  SizedBox(height: 9),
                  _buildTextField('Common landmark'),
                  SizedBox(height: 9),
                  _buildTextField('Telephone Number'),
                  SizedBox(height: 9),
                  Text('Save this address as'),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      _buildChoiceChip('Home'),
                      _buildChoiceChip('Office'),
                      _buildChoiceChip('Friends & Family'),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LocatingPickupAgentPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Pick up at this address',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return SizedBox(
      width: double.infinity, // Ensure the TextField uses the available width
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0), // Very oval shape
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0), // Reduced height
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label) {
    bool isSelected = _selectedChip == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: kPrimaryLight, // Color for selected chip
      backgroundColor: Colors.grey[200], // Color for unselected chip
      onSelected: (selected) {
        setState(() {
          _selectedChip = label;
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0), // Very oval shape
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0), // Reduced height
    );
  }
}
