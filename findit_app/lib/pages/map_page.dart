import 'package:findit_app/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/job_info.dart';

class MapPage extends StatefulWidget {

  final JobInfo jobInfo;
  final LatLng companyLocation;

  // Constructor
  const MapPage({super.key, required this.jobInfo, required this.companyLocation});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late GoogleMapController mapController;
  Map <String, Marker> markers = {};
  ScreenConfig screen = ScreenConfig();

  void addMarker(String id, LatLng location){
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: InfoWindow(
        title: widget.jobInfo.companyName,
      ),
    );

    markers[id] = marker;
    setState(() {});
  }

  // memory managment
  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          height: screen.blockSizeVertical * 3.22,
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GoogleMap(
        padding: const EdgeInsets.only(bottom: 20, left: 15),
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: widget.companyLocation,
          zoom: 17,
        ),
        onMapCreated: (controller) {
          mapController = controller;
          addMarker(widget.jobInfo.companyName, widget.companyLocation);
        },
        markers: markers.values.toSet(),
      ),
    );
  }
}