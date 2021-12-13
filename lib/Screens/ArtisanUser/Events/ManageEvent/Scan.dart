
import 'package:fixme/Screens/ArtisanUser/Events/ManageEvent/scanResult.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';


class Scan extends StatefulWidget {


  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    ScanController controller = ScanController();
    String qrcode = 'Unknown';

    return Scaffold(
      body: Center(
        child: ScanView(
          controller: controller,
          scanAreaScale: .7,
          scanLineColor: Colors.green.shade400,
          onCapture: (data) {
            print(data);
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation){
                return ScanResult(data:data);
              }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },)
            );
          },
        ),
      ),
    );
  }
}
