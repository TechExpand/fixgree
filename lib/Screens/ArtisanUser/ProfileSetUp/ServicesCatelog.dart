import 'dart:io';

import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PhotoCatelogPage extends StatefulWidget {
  final myPage;

  PhotoCatelogPage(this.myPage);
  @override
  PhotoCatelogPageState createState() => PhotoCatelogPageState();
}

class PhotoCatelogPageState extends State<PhotoCatelogPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    WebServices network = Provider.of<WebServices>(context);
    Utils data = Provider.of<Utils>(context);
    var datas = Provider.of<DataProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      body: WillPopScope(
        onWillPop: () {},
        child: Container(
          padding: const EdgeInsets.only(right: 24, left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                    '${datas.artisanVendorChoice == 'business' ? "Upload your product catalog" : "Upload your service catalog"}',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              /*    SizedBox(
                 child:  Center(
            child: SizedBox(
              height: 200, // card height
              child: PageView.builder(
                itemCount: data.image.length,
                controller: PageController(viewportFraction: 0.7),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.9,
                    child: Container(
                      width: 100,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Image.file(File(data.image[i].path,), fit: BoxFit.cover,)

                      ),
                    ),
                  );
                },
              ),
            ),
          ),
                    height: MediaQuery.of(context).size.height/3),*/
              SizedBox(
                  child: Center(
                    child: SizedBox(
                      height: 200, // card height
                      child: data.selectedImage2 == null
                          ? Text('')
                          : Container(
                              width: 200,
                              child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.file(
                                    File(
                                      data.selectedImage2.path,
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3),
              Material(
                elevation: 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(26)),
                    child: FlatButton(
                      disabledColor: Colors.white,
                      onPressed: () {
                        data.selectimage2(source: ImageSource.gallery);
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width / 1.3,
                              minHeight: 45.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Select/Upload Service Photo",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Align(
                  alignment: Alignment.center,
                  child: !network.loginState
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(26)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () {
                              network.loginSetState();
                              network.uploadCatalog(
                                scaffoldKey: scaffoldKey,
                                path: data.selectedImage2.path,
                                context: context,
                                uploadType: 'servicePicture',
                              );
                            },
                            color: Color(0xFF9B049B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 1.3,
                                    minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Upload",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 50.0, top: 20),
                          child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            accentColor: Color(
                                                                0xFF9B049B)),
                                                    child:
                                                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                       strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                                    )),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
