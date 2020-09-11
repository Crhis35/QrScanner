import 'package:flutter_map/flutter_map.dart';

import 'package:QrScanner/src/providers/db_provider.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = MapController();

  String typeMap = 'dark-v10';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordinates QR'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          ),
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFloatingButton(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 10,
      ),
      layers: [
        _createMap(),
        _createMark(scan),
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
          '{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoiY3JoaXMzNSIsImEiOiJjazhzd2tjaTUwMGc4M2VxdHo5bWlramdpIn0.4bw6syPVk1tUbdIRsVgZyA',
        'id': 'mapbox/$typeMap',
      },
    );
  }

  _createMark(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createFloatingButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        String aux = '';
        if (typeMap == 'streets-v11') {
          aux = 'light-v10';
        } else if (typeMap == 'light-v10') {
          aux = 'dark-v10';
        } else if (typeMap == 'dark-v10') {
          aux = 'outdoors-v11';
        } else if (typeMap == 'outdoors-v11') {
          aux = 'satellite-v9';
        } else {
          aux = 'streets-v11';
        }

        setState(() {
          typeMap = aux;
        });
      },
    );
  }
}
