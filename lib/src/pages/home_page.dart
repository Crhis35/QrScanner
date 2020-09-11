import 'dart:io';

import 'package:QrScanner/src/utils/utils.dart' as utils;
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/widgets.dart';

import 'package:QrScanner/src/bloc/scans_bloc.dart';
import 'package:QrScanner/src/models/scan_model.dart';
// import 'package:barcode_scan/barcode_scan.dart';

import 'package:QrScanner/src/pages/address_page.dart';
import 'package:QrScanner/src/pages/maps_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Qr Scanner'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: scansBloc.deleteAllScans,
            ),
          ],
        ),
        body: _callPage(currentIndex),
        bottomNavigationBar: _createBottomNavigation(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: () => _scanQR(context),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _createBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Address'),
        ),
      ],
    );
  }

  Widget _callPage(int actualPage) {
    switch (actualPage) {
      case 0:
        return MapsPage();
        break;
      case 1:
        return AddressPage();
        break;
      default:
        return MapsPage();
        break;
    }
  }

  _scanQR(BuildContext context) async {
    // https://www.google.com
    // geo:40.724233047051705,-74.00731459101564
    var futureString = await BarcodeScanner.scan();

    print(futureString);
    if (futureString != null) {
      final newScan = ScanModel(value: futureString.rawContent);
      scansBloc.addScan(newScan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750),
            () => utils.launchUrl(context, newScan));
      } else {
        utils.launchUrl(context, newScan);
      }
    }
  }
}
