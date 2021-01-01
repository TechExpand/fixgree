import 'dart:io';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/messages_widget.dart';
import 'package:fixme/Model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../strings.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //FocusNode textFieldFocus = FocusNode();

  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  File selectedImage;
  String message = '';

  void pickImage({@required ImageSource source, context}) async {
    final image = await ImagePicker.pickImage(source: source);
    setState(() => selectedImage = image);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    var network = Provider.of<WebServices>(context);
//    var data = Provider.of<Utils>(context, listen: false);
//    var datas = Provider.of<DataProvider>(context, listen: false);

//    var sender = User(
//      urlAvatar: network.profile_pic_file_name,
//      idUser: network.mobile_device_token,
//      name: network.firstName,
//      lastMessageTime: DateTime.now(),
//    );

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFA40C85),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          centerTitle: false,
          title: Text("PROFILE")),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              child: Stack(children: <Widget>[
                selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          selectedImage,
                          width: 150,
                          height: 150,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Icon(Icons.account_circle,
                        size: 160, color: Colors.black38),
                Positioned(
                  left: 107,
                  top: 103,
                  child: Container(
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                        color: Color(0xFFA40C85), shape: BoxShape.circle),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ]),
              onTap: () =>
                  pickImage(source: ImageSource.camera, context: context),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Icon(
                  Icons.person,
                  color: Color(0xFFA40C85),
                  size: 31,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.63,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Victory Onah",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    Text(
                      "This name will be visible to your Fixme contacts.",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.edit,
                  color: Color(0xFF777777),
                  size: 18,
                ),
                onTap: () => _editFullName(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15, top: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.79,
                  child: Divider(
                    color: Color(0xff999999),
                    thickness: 0.5,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Icon(
                  Icons.info,
                  color: Color(0xFFA40C85),
                  size: 31,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.63,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "I like punctuality above any other",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: Icon(
                  Icons.edit,
                  color: Color(0xFF777777),
                  size: 18,
                ),
                onTap: () => _editAbout(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.79,
                  child: Divider(
                    color: Color(0xff999999),
                    thickness: 0.5,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 70,
                child: Icon(
                  Icons.call,
                  color: Color(0xFFA40C85),
                  size: 31,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.63,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "+234 806 801 4944",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editAbout() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 155.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add About",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 33,
                            child: TextField(
                              controller: _controller2,
                              // onChanged: (String value) =>
                              //     setState(() => _controllerLenght = value.length),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),
                              ],
                              decoration: InputDecoration(
                                focusColor: Colors.black,
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA40C85)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA40C85)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.sentiment_satisfied,
                              color: Color(0xFFA40C85),
                              size: 25,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () {},
                        )
                      ])
                    ],
                  )));
        });
  }
  void _editFullName() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 155.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter your name",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 33,
                            child: TextField(
                              controller: _controller,
                              // onChanged: (String value) =>
                              //     setState(() => _controllerLenght = value.length),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),
                              ],
                              decoration: InputDecoration(
                                focusColor: Colors.black,
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA40C85)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFA40C85)),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.sentiment_satisfied,
                              color: Color(0xFFA40C85),
                              size: 25,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFFA40C85)),
                          ),
                          onTap: () {},
                        )
                      ])
                    ],
                  )));
        });
  }
}