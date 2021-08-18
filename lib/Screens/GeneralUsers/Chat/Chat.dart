import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'dart:convert';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/messages_widget.dart';
import 'package:fixme/Widgets/popup_menu.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

// import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final productSend;
  final productData;
  final user;
  final instantChat;
  final popData;
  final LocalFileSystem localFileSystem;

  ChatPage({
    this.productSend,
    this.productData,
    this.instantChat,
    this.popData,
    localFileSystem,
    @required this.user,
  }) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //FocusNode textFieldFocus = FocusNode();
  bool recordStatus = false;
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  final _controller = TextEditingController();

  // final _controller2 = TextEditingController();
  String message = '';

  init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);

        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
        });
      } else {
         await showTextToast(
                                                                            text: 'You must accept permissions.',
                                                                              context: context,
                                                                                             );
    
      }
    } catch (e) {}
  }






  final String serverToken =
      'AAAA2lAKGZU:APA91bFmok2miRE6jWBUgfmu5jhvxQGJ5ITwrcwrHMghkPOZCIYYxLu-rIs-ub6HQ5YdiEGx3jG2tMvmiEjq-KW4rEgGrckHNkGdFrO2iUDoidvmh867VQj0FKx-_cxbi8AQpR1S3cCu';





  Future<void> sendAndRetrieveMessage(body, token) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    final String serverToken =
        'AAAA2lAKGZU:APA91bFmok2miRE6jWBUgfmu5jhvxQGJ5ITwrcwrHMghkPOZCIYYxLu-rIs-ub6HQ5YdiEGx3jG2tMvmiEjq-KW4rEgGrckHNkGdFrO2iUDoidvmh867VQj0FKx-_cxbi8AQpR1S3cCu';

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': 'You Have a Message',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'notification_type': 'chat',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );

  }





  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Start Again';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }





      sendMessageTriggerFirst() async {
      var datass = Provider.of<DataProvider>(context, listen: false);
      var network = Provider.of<WebServices>(context, listen: false);
      if(widget.instantChat != 'market'){
        message =
        """Hey, i would love to get this product from you!.Product Name: ${widget.productData['product_name']} Product Price: ₦${widget.productData['price']}""";
      }else{
        message =
        """Hey, i would love to get this product from you!.Product Name: ${widget.productData.product_name} Product Price: ₦${widget.productData.price}""";
      }


        String productImage;
        if(widget.instantChat == 'market'){
          for (dynamic item in widget.productData.productImages){
            productImage = 'https://uploads.fixme.ng/originals/${item['imageFileName']}';
          }
        }else{
          for (dynamic item in widget.productData['productImages']){
            productImage = 'https://uploads.fixme.ng/originals/${item['imageFileName']}';
          }
        }

        await FirebaseApi.uploadmessage(
            widget.user.idUser,
            network.mobileDeviceToken,
            message,
            context,
            '${network.userId}-${widget.user.id}',
          productImage:productImage,
        );
        sendAndRetrieveMessage(message,  widget.user.fcmToken);
      }



  _stopExit() async {
    var result = await _recorder.stop();
    // File file = widget.localFileSystem.file(result.path);


    _current = result;
    _currentStatus = _current.status;

  }

  initilizeExit() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory =
          await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = FlutterAudioRecorder(customPath,
            audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);

        // should be "Initialized", if all working fine

        _current = current;
        _currentStatus = current.status;

      } else {
        await showTextToast(
          text: 'You must accept permissions.',
          context: context,
        );

      }
    } catch (e) {}
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    widget.productSend==null?null:sendMessageTriggerFirst();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
    var datass = Provider.of<DataProvider>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    void pickImage({@required ImageSource source, context}) async {
      final picker = ImagePicker();
      var selectedImage = await picker.pickImage(source: source);
      FocusScope.of(context).unfocus();
      // _controller2.clear();
      FirebaseApi.uploadCheckChat(widget.user.idUser);
      _controller.clear();
      datas.setWritingTo(false);
      await FirebaseApi.uploadImage(
              widget.user.idUser,
              network.mobileDeviceToken,
              selectedImage,
              context,
              '${network.userId}-${widget.user.id}',
        false,
      )
          .then((value) {
        sendAndRetrieveMessage(message,  widget.user.fcmToken);
      });
    }

    pickDoc() async {
      final selectedImage =
      await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'csv',
        'xls',
        'xlsx',
        'ods',
        'txt',
        'html',
        'png',
        'jpeg',
        'jpg',
        'gif'
      ]);

      FocusScope.of(context).unfocus();
      FirebaseApi.uploadCheckChat(widget.user.idUser);

      // _controller2.clear();
      _controller.clear();
      datas.setWritingTo(false);
      await FirebaseApi.uploadImage(
          widget.user.idUser,
          network.mobileDeviceToken,
          selectedImage,
          context,
          '${network.userId}-${widget.user.id}',
      true,
      );
      sendAndRetrieveMessage(message,  widget.user.fcmToken);
    }

    void record({record, context}) async {
      FocusScope.of(context).unfocus();
      // _controller2.clear();
      FirebaseApi.uploadCheckChat(widget.user.idUser);
      _controller.clear();
      datas.setWritingTo(false);
      await FirebaseApi.uploadRecord(
          widget.user.idUser,
          network.mobileDeviceToken,
          record,
          context,
          '${network.userId}-${widget.user.id}');
      sendAndRetrieveMessage(message,  widget.user.fcmToken);
    }

    sendMessage() async {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FirebaseApi.uploadCheckChat(widget.user.idUser);
      _controller.clear();
      datas.setWritingTo(false);
      await FirebaseApi.uploadmessage(
          widget.user.idUser,
          network.mobileDeviceToken,
          message,
          context,
          '${network.userId}-${widget.user.id}');
      sendAndRetrieveMessage(message,  widget.user.fcmToken);
    }

//     void _modalBottomSheetRecord() {
//       showModalBottomSheet(
//           context: context,
//           builder: (builder) {
//             return StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setState) {
//                   _start() async {
//                     try {
//                       await _recorder.start();
//                       var recording = await _recorder.current(channel: 0);
//                       setState(() {
//                         _current = recording;
//                       });
//
//                       const tick = const Duration(milliseconds: 50);
//                       new Timer.periodic(tick, (Timer t) async {
//                         if (_currentStatus == RecordingStatus.Stopped) {
//                           t.cancel();
//                         }
//
//                         var current = await _recorder.current(channel: 0);
//                         // print(current.status);
//                         setState(() {
//                           _current = current;
//                           _currentStatus = _current.status;
//                         });
//                       });
//                     } catch (e) {}
//                   }
//
//                   _resume() async {
//                     await _recorder.resume();
//                     setState(() {});
//                   }
//
//                   _pause() async {
//                     await _recorder.pause();
//                     setState(() {});
//                   }
//
//                   _stop() async {
//                     var result = await _recorder.stop();
//                     // File file = widget.localFileSystem.file(result.path);
//
//                     setState(() {
//                       _current = result;
//                       _currentStatus = _current.status;
//                     });
//                   }
//
//                   initilize() async {
//                     try {
//                       if (await FlutterAudioRecorder.hasPermissions) {
//                         String customPath = '/flutter_audio_recorder_';
//                         io.Directory appDocDirectory;
// //        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
//                         if (io.Platform.isIOS) {
//                           appDocDirectory =
//                           await getApplicationDocumentsDirectory();
//                         } else {
//                           appDocDirectory = await getExternalStorageDirectory();
//                         }
//
//                         // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//                         customPath = appDocDirectory.path +
//                             customPath +
//                             DateTime.now().millisecondsSinceEpoch.toString();
//
//                         // .wav <---> AudioFormat.WAV
//                         // .mp4 .m4a .aac <---> AudioFormat.AAC
//                         // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//                         _recorder = FlutterAudioRecorder(customPath,
//                             audioFormat: AudioFormat.WAV);
//
//                         await _recorder.initialized;
//                         // after initialization
//                         var current = await _recorder.current(channel: 0);
//
//                         // should be "Initialized", if all working fine
//                         setState(() {
//                           _current = current;
//                           _currentStatus = current.status;
//                         });
//                       } else {
//                         await showTextToast(
//                           text: 'You must accept permissions.',
//                           context: context,
//                         );
//
//                       }
//                     } catch (e) {}
//                   }
//
//
//
//
//                   return new Container(
//                 height: 100.0,
//                 color: Colors.transparent,
//                 //could change this to Color(0xFF737373),
//                 //so you don't have to change MaterialApp canvasColor
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 4.0, bottom: 4, left: 8, right: 8),
//                   child: Column(children: <Widget>[
//                     new Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: new FlatButton(
//                             onPressed: () {
//                               switch (_currentStatus) {
//                                 case RecordingStatus.Initialized:
//                                   {
//                                     _start();
//                                     break;
//                                   }
//                                 case RecordingStatus.Recording:
//                                   {
//                                     _pause();
//                                     break;
//                                   }
//                                 case RecordingStatus.Paused:
//                                   {
//                                     _resume();
//                                     break;
//                                   }
//                                 case RecordingStatus.Stopped:
//                                   {
//                                     initilize();
//                                     break;
//                                   }
//                                 default:
//                                   break;
//                               }
//                             },
//                             child: _buildText(_currentStatus),
//                             color: Color(0xFFA40C85),
//                           ),
//                         ),
//                         new FlatButton(
//                           onPressed: _currentStatus != RecordingStatus.Unset
//                               ? _stop
//                               : null,
//                           child: new Text("Stop",
//                               style: TextStyle(color: Colors.white)),
//                           color: Color(0xFFA40C85).withOpacity(.5),
//                         ),
//                         _currentStatus == RecordingStatus.Stopped
//                             ? new InkWell(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                   record(
//                                     context: context,
//                                     record: _current,
//                                   );
//                                 },
//                                 child: Icon(Icons.send,
//                                     size: 40, color: Colors.black),
//                               )
//                             : Icon(Icons.send, size: 40, color: Colors.black54),
//                       ],
//                     ),
//                     /*  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: new Text("Status : $_currentStatus"),
//                 ),*/
//                     Text(
//                         "Recording Duration : ${_current?.duration.toString()}"),
//                   ]),
//                 ),
//               );
//             });
//           });
//     }
//

    var numberDialog = AnimatedContainer(
      height: 80,
      duration: Duration(seconds: 1),
      margin: const EdgeInsets.all(3.0),
      child: Align(
        alignment: Alignment(0.75, 0.75),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                child: AnimatedContainer(
                  height: 80,
                  duration: Duration(seconds: 1),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              child: StatefulBuilder(builder: (context, setState) {
                                return Container(
                                      height: 80.0,
                                      color: Colors.transparent,
                                      //could change this to Color(0xFF737373),
                                      //so you don't have to change MaterialApp canvasColor
                                      child: Column(
                                        children: [
                                         Card(
                                                color:Colors.white ,
                                               // padding: EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        pickDoc();
                                                      },
                                                      child: Tab(
                                                          icon: Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFA40C85),
                                                                  shape: BoxShape.circle),
                                                              child: Icon(
                                                                Icons.attachment,
                                                                color: Colors.white,
                                                              )),
                                                          text: 'Attachment'),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        pickImage(
                                                            source: ImageSource.camera, context: context);
                                                      },
                                                      child: Tab(
                                                          icon: Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFA40C85),
                                                                  shape: BoxShape.circle),
                                                              child: Icon(Icons.camera_alt,
                                                                  color: Colors.white)),
                                                          text: 'Camera'),
                                                    ),

                                                    InkWell(
                                                      onTap: () {
                                                        pickImage(
                                                            source: ImageSource.gallery,
                                                            context: context);
                                                      },
                                                      child: Tab(
                                                          icon: Container(
                                                              width: 40,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFA40C85),
                                                                  shape: BoxShape.circle),
                                                              child: Center(
                                                                child: Icon(Icons.image,
                                                                    color: Colors.white),
                                                              )),
                                                          text: 'Gallary'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    );

                              }),
                            ),
                          ],
                        ),
                      ),
                ),
              Padding(
                padding: const EdgeInsets.only(left:8.0, bottom: 30, ),
                child:  InkWell(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    Navigator.pop(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Color(0xFFA40C85),
                          shape: BoxShape.circle),
                      child: Icon(Icons.clear, color: Colors.white,)),
                ),
              ),
            ],
          ),
        ),
        ),

    );


    void _modalBottomSheetMenu(datas) {
      print( widget.user.fcmToken);
      // showDialog(
      //   barrierColor: Colors.transparent,
      //     context: context,
      //     builder: (builder) {
      //       return numberDialog;
      //     });
      showGeneralDialog(
          barrierColor: Colors.transparent,
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * -200, 0.0),
              child: Opacity(
                  opacity: a1.value,
                  child: numberDialog
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {});
    }











    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9B049B),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            _stopExit();
            initilizeExit();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        centerTitle: false,
        title: Text(
          '${widget.user.name}'.capitalizeFirstOfEach,
        ),
        actions: <Widget>[
          widget.user.idUser == null ||
                  widget.user.idUser.toString().isEmpty ||
                  network.mobileDeviceToken == null
              ? Text('')
              : IconButton(
                  icon: Icon(
                    Icons.videocam,
                    size: 30,
                  ),
                  onPressed: () {
                    datas.onJoin(
                      reciever: widget.user.urlAvatar,
                      channelID: data.getRandomString(10),
                      userID: widget.user.idUser,
                      myusername: network.firstName,
                      callerId: network.mobileDeviceToken,
                      calltype: 'video',
                      myavater:
                          'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                      context: context,
                    );
                  },
                ),
          IconButton(
            icon: Icon(
              Icons.phone,
              size: 25,
            ),
            onPressed: widget.user.idUser == null ||
                    widget.user.idUser.toString().isEmpty ||
                    network.mobileDeviceToken == null
                ? () {
                    data.makePhoneCall(widget.user.userMobile);
                  }
                : () {
                    datas.onJoin(
                      reciever: widget.user.urlAvatar,
                      channelID: data.getRandomString(10),
                      userID: widget.user.idUser,
                      myusername: network.firstName,
                      callerId: network.mobileDeviceToken,
                      calltype: 'audio',
                      myavater:
                          'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
                      context: context,
                    );
                  },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PopUpMenu(
                idUser: widget.user.idUser,
                user: widget.user,
                scaffoldKey: scaffoldKey,
                popData: widget.popData),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: (){
          _stopExit();
          initilizeExit();
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
             child: Image.asset('assets/images/chat.png', fit: BoxFit.cover,),
            ),
            Column(
              children: [
                Expanded(
                  child: Container(
                    // padding: EdgeInsets.all(10),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    // ),
                    child: MessagesWidget(
                        idUser: widget.user.idUser,
                        user: widget.user), //network.mobile_device_token
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setState) {



                    _start() async {
                      try {
                        await _recorder.start();
                        var recording = await _recorder.current(channel: 0);
                        setState(() {
                          _current = recording;
                        });

                        const tick = const Duration(milliseconds: 50);
                        new Timer.periodic(tick, (Timer t) async {
                          if (_currentStatus == RecordingStatus.Stopped) {
                            t.cancel();
                          }

                          var current = await _recorder.current(channel: 0);
                          // print(current.status);
                          setState(() {
                            _current = current;
                            _currentStatus = _current.status;
                          });
                        });
                      } catch (e) {}
                    }



                    _stop() async {
                      var result = await _recorder.stop();
                      // File file = widget.localFileSystem.file(result.path);

                      setState(() {
                        _current = result;
                        _currentStatus = _current.status;
                      });
                    }

                    initilize() async {
                      try {
                        if (await FlutterAudioRecorder.hasPermissions) {
                          String customPath = '/flutter_audio_recorder_';
                          io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
                          if (io.Platform.isIOS) {
                            appDocDirectory =
                            await getApplicationDocumentsDirectory();
                          } else {
                            appDocDirectory = await getExternalStorageDirectory();
                          }

                          // can add extension like ".mp4" ".wav" ".m4a" ".aac"
                          customPath = appDocDirectory.path +
                              customPath +
                              DateTime.now().millisecondsSinceEpoch.toString();

                          // .wav <---> AudioFormat.WAV
                          // .mp4 .m4a .aac <---> AudioFormat.AAC
                          // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
                          _recorder = FlutterAudioRecorder(customPath,
                              audioFormat: AudioFormat.WAV);

                          await _recorder.initialized;
                          // after initialization
                          var current = await _recorder.current(channel: 0);

                          // should be "Initialized", if all working fine
                          setState(() {
                            _current = current;
                            _currentStatus = current.status;
                          });
                        } else {
                          await showTextToast(
                            text: 'You must accept permissions.',
                            context: context,
                          );

                        }
                      } catch (e) {}
                    }


                    return Container(
                      height: 65,
                      color: Colors.white,
                      child: widget.user.idUser == null ||
                              widget.user.idUser.toString().isEmpty ||
                              network.mobileDeviceToken == null
                          ? Center(
                              child: Text(
                              'You Cannot Send Message. You can Contact the user through direct Phone Call by Clicking the phone Icon above',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 5,
                                ),

                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        color: Color(0xFFDBDBDB),
                                        height: 53,
                                        width: recordStatus?MediaQuery.of(context).size.width / 1.63:MediaQuery.of(context).size.width / 1.18,
                                        child: Container(
                                          margin: EdgeInsets.only(left: 50),
                                          child: TextField(
                                            onTap: ()async{
                                           String  token = await FirebaseMessaging.instance.getToken();
                                              FirebaseApi
                                            .updateUsertoRead(
                                                idUser: widget.user.idUser,
                                                idArtisan: network.mobileDeviceToken);

                                              if(widget.user.fcmToken.toString() != token){
                                                FirebaseApi.updateUserFCMToken(
                                                    idUser: widget.user.idUser,
                                                    idArtisan: network.mobileDeviceToken,
                                                token: token,
                                                );
                                              }
                                              },
                                            controller: _controller,
                                            onChanged: (val) {
                                              (val.length > 0 && val.trim() != "")
                                                  ? datas.setWritingTo(true)
                                                  : datas.setWritingTo(false);
                                              message = val;
                                              setState((){
                                                print(message);
                                              });
                                            },
                                            textCapitalization: TextCapitalization.sentences,
                                            autocorrect: true,
                                            // focusNode: textFieldFocus,
                                            enableSuggestions: true,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              hintText: 'Type a message...',
                                              hintStyle: TextStyle(color: Colors.black54),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              isDense: true,
                                              filled: true,
                                              fillColor: Color(0xFFDBDBDB),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top:6,
                                      left:5,
                                      child: InkWell(
                                        onTap: () {
                                          FocusScopeNode currentFocus = FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          _modalBottomSheetMenu(datas);
                                        },
                                        child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Color(0xFFA40C85), shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 35,
                                            )),
                                      ),
                                    ),
                                  ],

                                ),
                                // Selector<DataProvider, bool>(
                                //   selector: (_, model) => model.isWriting,
                                //   builder: (_, mo, __) {
                                //     return mo
                                //         ?
                                recordStatus?AnimatedOpacity(
                                  opacity: recordStatus?1:0.5,
                                  duration: Duration(microseconds: 1000),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 1,),
                                          InkWell(
                                            onTap: () {
                                              setState((){
                                                recordStatus = false;
                                                _stop();
                                                initilize();
                                              });
                                            },
                                            child: Icon(
                                                  Icons.cancel_outlined,
                                                  color: Colors.red,
                                                  size: 43,
                                                ),
                                          ),
                                          SizedBox(width: 5,),
                                          Text("${_current?.duration.toString().substring(2,7)}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                          SizedBox(width: 5,),
                                          InkWell(
                                            onTap: () {
    setState((){
                                              recordStatus = false;
                                              _stop().then((value) {
                                                record(
                                                  context: context,
                                                  record: _current,
                                                );
                                              }).then((value){
                                                initilize();
                                              });


    });
                                            },
                                            child: Container(

                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.green, width: 4),
                                                    color: Colors.transparent, shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.done,
                                                  color: Colors.green,
                                                  size: 27,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                :Container(),
                                recordStatus? Container():datass.isWriting
                                    ? Container(
                                  margin: EdgeInsets.only(left:5),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFA40C85),
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 44,
                                  width: 44,
                                      child: Center(
                                        child: IconButton(
                                            onPressed: sendMessage,
                                            icon: Icon(Icons.send, color: Colors.white),
                                          ),
                                      ),
                                    )
                                    : Container(
                                  margin: EdgeInsets.only(left:5),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFA40C85),
                                      borderRadius: BorderRadius.circular(100)),
                                  height: 44,
                                      width: 44,
                                      child: Center(
                                        child: IconButton(
                                            onPressed: () {
                                              setState((){
                                                recordStatus = true;
                                              });
                                              switch (_currentStatus) {
                                                case RecordingStatus.Initialized:
                                                  {
                                                    _start();
                                                    break;
                                                  }
                                                case RecordingStatus.Stopped:
                                                  {
                                                    initilize();
                                                    break;
                                                  }
                                                default:
                                                  break;
                                              }
                                             //_modalBottomSheetRecord();
                                            },
                                            icon: Icon(
                                              Icons.mic,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                      ),
                                    )
                                //;
                                //   },
                                // ),
                              ],
                            ),
                    );
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//message.trim().isEmpty
//? null
//:
