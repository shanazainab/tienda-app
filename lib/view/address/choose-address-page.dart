import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class ChooseAddressPage extends StatefulWidget {
  @override
  _ChooseAddressPageState createState() => _ChooseAddressPageState();
}

class _ChooseAddressPageState extends State<ChooseAddressPage> {
  Completer<GoogleMapController> _controller = Completer();
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyDBMARSuk2l-TxaUBlHY3m5RVb7bN2C08c");

  static CameraPosition initialPosition = CameraPosition(
    target: LatLng(25.1247178, 55.4083117),
    zoom: 18,
  );

  LatLng chosenLocation;
  String address;
  bool _mapLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height - 60,
              child: GoogleMap(
                compassEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                mapType: MapType.normal,
                onCameraMove: (cameraPosition) {
                  chosenLocation = new LatLng(cameraPosition.target.latitude,
                      cameraPosition.target.longitude);
                  address = 'fetching address..';
                  setState(() {});
                },
                onCameraIdle: () async {
                  List<Placemark> placemark = await Geolocator()
                      .placemarkFromCoordinates(
                          chosenLocation.latitude, chosenLocation.longitude);
                  setState(() {
                    address = placemark[0].name +
                        " " +
                        placemark[0].locality +
                        ' ' +
                        placemark[0].subLocality;
                  });
                },
                initialCameraPosition: initialPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {
                    _mapLoading = false;
                  });
                },
              )),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    margin: EdgeInsets.only(left: 16, right: 16),
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            showPrediction();
                          },
                          child: Row(children: <Widget>[
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                  leading: Icon(Icons.location_on),
                                  title: Text(
                                    address == null
                                        ? "fetching address.."
                                        : address,
                                    style: TextStyle(
                                        color: Color(0xFF2A2E43),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ButtonTheme(
                      height: 48,
                      minWidth: MediaQuery.of(context).size.width - 48,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(05)),
                      child: RaisedButton(
                        color: Colors.grey,
                        onPressed: () {
                          //   handleNext(context);
                        },
                        child: Text(
                          "CONFIRM LOCATION",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Image.asset(
                  "assets/icons/address-pin.png",
                  height: 30,
                  width: 30,
                  fit: BoxFit.fitHeight,
                ),
              ))
        ],
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: new LatLng(position.latitude, position.longitude), zoom: 18)));

    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      address = placemark[0].name +
          " " +
          placemark[0].locality +
          ' ' +
          placemark[0].subLocality;
    });
  }

  Future<void> showPrediction() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyDBMARSuk2l-TxaUBlHY3m5RVb7bN2C08c",
        mode: Mode.fullscreen);

    displayPrediction(p);

  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {

      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

    }
  }
}
