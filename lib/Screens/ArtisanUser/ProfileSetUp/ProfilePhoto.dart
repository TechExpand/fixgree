import 'dart:io';

import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePhotoPage extends StatefulWidget {
  final myPage;
  ProfilePhotoPage(this.myPage);
  @override
  ProfilePhotoPageState createState() => ProfilePhotoPageState();
}

class ProfilePhotoPageState extends State<ProfilePhotoPage> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(right: 24, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 13.0, bottom: 13),
            child: Text(
                'Please upload a professional portrait that clearly shows your face or upload your business logo.'),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: data.selectedImage == null
                    ? CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 85,
                        ),
                        radius: 55,
                        foregroundColor: Color(0xFFDB5B04).withOpacity(0.75),
                        backgroundColor: Color(0xFFDB5B04).withOpacity(0.75),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 55,
                        backgroundImage:
                            FileImage(File(data.selectedImage.path)),
                      )),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              data.selectimage(source: ImageSource.gallery);
            },
            child: Container(
                width: MediaQuery.of(context).size.width / 0.2,
                height: 50,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xFF9B049B)),
                    Text('Add Profile Photo',
                        style: TextStyle(color: Color(0xFF9B049B))),
                  ],
                )),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Color(0xFF9B049B)),
                )),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: InkWell(
                  onTap: () {
                    widget.myPage.jumpToPage(3);
                  },
                  child: Text('Skip this step')),
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
                        onPressed: data.selectedImage == null
                            ? null
                            : () {
                                network.loginSetState();
                                network.uploadPhoto(
                                  path: data.selectedImage.path,
                                  context: context,
                                  uploadType: 'profilePicture',
                                  navigate: widget.myPage,
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
                              "Next",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 50.0, top: 20),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                      ),
                    )),
        ],
      ),
    );
  }
}
