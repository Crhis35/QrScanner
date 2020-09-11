import 'package:flutter/material.dart';

import 'package:QrScanner/src/bloc/scans_bloc.dart';
import 'package:QrScanner/src/models/scan_model.dart';
import 'package:QrScanner/src/utils/utils.dart' as utils;

class AddressPage extends StatelessWidget {
  final scanBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    scanBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scanBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        final scans = snapshot.data;
        if (scans.length == 0)
          return Center(
            child: Text('No hay informacion'),
          );

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red),
            child: ListTile(
              leading: Icon(Icons.cloud_queue,
                  color: Theme.of(context).primaryColor),
              title: Text(scans[i].value),
              subtitle: Text('ID: ${scans[i].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => utils.launchUrl(context, scans[i]),
            ),
            onDismissed: (direction) => scanBloc.deleteScan(scans[i].id),
          ),
        );
      },
    );
  }
}
