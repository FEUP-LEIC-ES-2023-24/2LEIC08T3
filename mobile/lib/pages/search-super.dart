import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';


class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
	  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

const key = 'AIzaSyCVa4mxHXzjuytYsXWlTBAYb7NxpTKFFLI';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {
	  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(41.1780, -8.5980), 
    zoom: 13
  );

  Set<Marker> markersList = {};

	late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: const Text("Supermarket Search"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition, 
            markers: markersList, 
            mapType: MapType.normal, 
            onMapCreated: (GoogleMapController controller){
              googleMapController = controller;
            },
          ),
          ElevatedButton(
            onPressed: _handlePressButton,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  return const Color(0xff4b986c);
                },
              ),
            ),
            child: const Text(
              "Search",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
              ),    
          )
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context, 
      apiKey: key, 
      onError: onError,
      mode: _mode, 
      language: 'pt', 
      strictbounds: false, 
      types: [""], 
      decoration: InputDecoration(
        hintText: 'Search', 
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), 
          borderSide: BorderSide(color: Colors.white)
        )
      ), 
      components: [Component(Component.country,"pt")]
    );

    displayPrediction(p!,homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }  

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async{
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: key,
      apiHeaders: await const GoogleApiHeaders().getHeaders()
    );

      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

      final lat = detail.result.geometry!.location.lat;
      final long = detail.result.geometry!.location.lng;

      markersList.clear();
      markersList.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat, long), infoWindow: InfoWindow(title: detail.result.name)));

      setState(() {});

      googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 14));
  }
}