
import 'dart:io';
import 'dart:typed_data';

import 'package:fixme/Screens/GeneralUsers/Wallet/Providers/BankProvider.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Screens/GeneralUsers/Wallet/SeeBeneficiaries.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Model/BankInfo.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class Barcode extends StatefulWidget {
  Barcode({this.refToken});
  // String userId;
  String refToken;


  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {

  ScreenshotController screenshotController = ScreenshotController();
  var transferModes = ['Direct \n Transfer', 'Wallet \n Transfer'];

  TextEditingController accountNo = new TextEditingController();

  BorderRadiusGeometry radiusTop = BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
  );

  BorderRadiusGeometry radiusBottom = BorderRadius.only(
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  );
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _requestPermission();
  }


  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;


    return ChangeNotifierProvider<BankProvider>(
      create: (_) => BankProvider(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
            ),
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: 140,
                margin: const EdgeInsets.only(top: 20, right: 5),
                alignment: Alignment.center,
                child: Image.asset('assets/images/fixme.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Text('Paid To Fixme',
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Firesans',
                            height: 1.4,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w600),textAlign: TextAlign.center ),
                  ],
                ),
              ),

              Center(
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Screenshot(
                              controller: screenshotController,
                              child:  Container(
                                color: Colors.white,
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SfBarcodeGenerator(
                                      value: widget.refToken,
                                      symbology: QRCode(),
                                    ),
                                ),
                                ),
                            ),
                            )),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(26)),
                          child: FlatButton(
                            onPressed: () async{
                              screenshotController.capture().then((Uint8List image) async {
                                final result = await ImageGallerySaver.saveImage(image);
                                showTextToast(
                                  text: 'image saved to gallery',
                                  context: context,
                                );
                                // });
                              }).catchError((onError) {
                                print(onError);
                              });
                            },
                            color: Color(0xFF9B049B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(26)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width / 1.3,
                                    minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "SAVE TO PHONE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        );
      },
    );
  }


  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);

  }
  }




