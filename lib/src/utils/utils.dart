import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:QrScanner/src/providers/db_provider.dart';

launchUrl(BuildContext context, ScanModel scan) async {
  if (scan.type.contains('http')) {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${scan.value}';
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
