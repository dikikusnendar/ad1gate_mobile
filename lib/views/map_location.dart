import 'package:adira_finance/main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class MapPage extends StatefulWidget {
  final ValueChanged<Map> setAddress;

  const MapPage({Key key, this.setAddress}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var _latitude,_longitude;
  final Set<Marker> _markers = {};
  LatLng _currentPosition;
  var _loadMaps = false;
  String _addressFromMap = "";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  _getLocation() async{
    setState(() {
      _loadMaps = true;
    });
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.latitude);
    print(_locationData.longitude);
    setState(() {
      _currentPosition = LatLng(_locationData.latitude, _locationData.longitude);
      _loadMaps = false;
    });
    _markers.add(
      Marker(
        markerId:
        MarkerId("${_locationData.latitude}, ${_locationData.longitude}"),
        icon: BitmapDescriptor.defaultMarker,
        position: _currentPosition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Location",style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
      ),
      body:
          Container(
            margin: EdgeInsets.only(left: 8,right: 8,top: 8),
            child: _loadMaps
                ?
            Center(child: CircularProgressIndicator())
                :
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 27.0,
                ),
                markers: _markers,
                indoorViewEnabled: true,
                buildingsEnabled: true,
                compassEnabled: true,
                onTap: (position) {
                  setState(() {
                    _latitude = position.latitude;
                    _longitude = position.longitude;
                    _markers.clear();
                    _markers.add(
                      Marker(
                        markerId:
                        MarkerId("${position.latitude}, ${position.longitude}"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: position,
                      ),
                    );
                  });
                  getUserLocation(position.latitude,position.longitude);
                }),
          ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: 8,right: 8,bottom: 8,top: 8),
          child: RaisedButton(
            padding: EdgeInsets.only(top: 8,bottom: 8),
            onPressed: (){
              var _value = {"address": _addressFromMap,"latitude":_latitude,"longitude":_longitude};
              widget.setAddress(_value);
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Set Location',style: TextStyle(fontFamily: "NunitoSans",color: Colors.black))
              ],
            ),color: myPrimaryColor,
          )
        ),
      ),
    );
  }

  getUserLocation(double lat, double long) async {

    final coordinates = new Coordinates(lat, long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    setState(() {
      _addressFromMap = first.addressLine;
    });
    _showDialog(first.addressLine);
  }

  void _showDialog(String address) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alamat pilihan anda"),
          content: new Text(address,textAlign: TextAlign.justify,style: TextStyle(fontFamily: "NunitoSans")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
