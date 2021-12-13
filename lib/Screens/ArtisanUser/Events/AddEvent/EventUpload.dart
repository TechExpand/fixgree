import 'dart:io';

import 'package:fixme/Screens/ArtisanUser/Events/AddEvent/steptwoEvent.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EventPhotoPage extends StatefulWidget {
  @override
  EventPhotoPageState createState() => EventPhotoPageState();
}

class EventPhotoPageState extends State<EventPhotoPage> {
  @override
  Widget build(BuildContext context) {
    //var data = Provider.of<Utils>(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Step 1', style: TextStyle(color: Color(0xFF9B049B)),),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading:  IconButton(
          icon:Icon(Icons.keyboard_backspace, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<Utils>(
          builder: (context, conData, child) {
            return Container(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: ListView(
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatefulBuilder(builder: (context, setState){
                    return Column(
                      children: [
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: conData.selectedImage == null
                                  ? Stack(
                                    children: [
                                      Container(
                                child: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 85,
                                ),
                               height: 150,
                               width: 150,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(8),
                                 color: Colors.grey,
                               ),
                              ),
                                      InkWell(
                                        onTap: (){
                                          conData.selectimage(source: ImageSource.gallery).then((value){
                                            setState((){
                                              print('s');
                                            });
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 130),
                                          height:30,
                                          width:30,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle
                                          ),
                                          child: Icon(Icons.add, color: Colors.white,),
                                        ),
                                      )
                                    ],
                                  )
                                  : Stack(
                                    children: [
                                      Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        image:  FileImage(File(conData.selectedImage.path),
                                          scale: 2.34
                                      ),
                                ),
                              )),
                                      InkWell(
                                        onTap: (){
                                          conData.selectimage(source: ImageSource.gallery).then((value){
                                            setState((){
                                              print('s');
                                            });
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 130),
                                          height:30,
                                          width:30,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle
                                          ),
                                          child: Icon(Icons.add, color: Colors.white,),
                                        ),
                                      )
                                    ],
                                  ),
                        )),

                      ],
                    );

                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 13.0, bottom: 13),
                    child: Text(
                        'Please upload a professional portrait that clearly'
                            ' shows your face or upload your business logo.',
                      textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 30,),
                  Align(
                      alignment: Alignment.center,
                      child: !network.loginState
                          ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(26)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed: conData.selectedImage == null
                              ? null
                              : () {

                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return  SignUpAddress();
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                            // network.loginSetState();
                            // network.uploadPhoto(
                            //   path: conData.selectedImage.path,
                            //   context: context,
                            //   uploadType: 'profilePicture',
                            //   navigate: widget.myPage,
                            //   name: conData.selectedImage.name,
                            // );
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
                      )

                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
