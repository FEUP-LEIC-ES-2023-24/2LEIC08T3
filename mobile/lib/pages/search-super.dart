import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';


class SearchSuperPage extends StatefulWidget {
  const SearchSuperPage({super.key});

  @override
  State<SearchSuperPage> createState() => _SearchSuperPageState();
}

const key = '';
final homeKey = GlobalKey<ScaffoldState>();

class _SearchSuperPageState extends State<SearchSuperPage> {
  static const CameraPosition feup = CameraPosition(target: LatLng(41.1780, -8.5980), zoom: 13);
  Set<Marker> markers = {};
  late GoogleMapController googleMapController;
  final Mode mode = Mode.overlay;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeKey,
      appBar: AppBar(
        title: const Text("Supermarket Search"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: feup, 
            markers: markers, 
            mapType: MapType.normal, 
            onMapCreated: (GoogleMapController controller){
              googleMapController = controller;
            },
          ),
          ElevatedButton(onPressed: search, child: const Text("Search Supermarket"))
        ],
      ),
    );
  }

  Future<void> search() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context, 
      apiKey: key, 
      mode: mode, 
      language: 'en', 
      strictbounds: false, 
      types: [""], 
      decoration: InputDecoration(
        hintText: 'Search', 
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), 
          borderSide: BorderSide(color: Colors.white)
        )
      ), 
      components: [Component(Component.country,"usa")]
    );

    displayPrediction(p!,homeKey.currentState);
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async{
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: key,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

      final lat = detail.result.geometry!.location.lat;
      final long = detail.result.geometry!.location.lng;

      markers.clear();
      markers.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat, long), infoWindow: InfoWindow(title: detail.result.name)));

      setState(() {});

      googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 14));
  }
}