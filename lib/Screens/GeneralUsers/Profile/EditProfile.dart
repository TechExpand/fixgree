import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _statusController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  PickedFile selectedImage;
  final picker = ImagePicker();

  Future<Map> user;

  void pickImage({@required ImageSource source, context}) async {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    var image = await picker.getImage(source: source);
    setState(() => selectedImage = image);

    String imageName = await network.uploadProfilePhoto(
      path: selectedImage.path,
    );

    data.storeData('profile_pic_file_name', imageName);
    network.initializeValues();
    update(context);
  }

  update(BuildContext context) async {
    setState(() {
      user = getUserDetails(context);
    });
  }

  Future<Map> getUserDetails(BuildContext buildContext) async {
    var data = Provider.of<Utils>(buildContext, listen: false);
    String firstname = await data.getData('firstName');
    String lastname = await data.getData('lastName');
    String about = await data.getData('about') ?? 'Nothing';
    String phone = await data.getData('phoneNum');
    String address = await data.getData('address') ?? 'Nothing here';
    String photoUrl = await data.getData('profile_pic_file_name');

    // firstname1 = firstname;
    // lastname1 = lastname;
    // bio1 = about;

    print('The URL: $photoUrl');

    Map userDetails = {
      'firstname': firstname,
      'lastname': lastname,
      'about': about,
      'phone': phone,
      'address': address,
      'photoUrl': 'https://uploads.fixme.ng/originals/$photoUrl'
    };

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    update(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
        ),
        title: Text('Edit profile',
            style: GoogleFonts.openSans(
                color: Colors.black87,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600)),
        // centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map>(
          future: user,
          builder: (context, AsyncSnapshot<Map> snapshot) {
            Widget mainWidget;
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                mainWidget = Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Color(0xFF9B049B)),
                          child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Text('No Data',
                          style: TextStyle(
                              // letterSpacing: 4,
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              } else {
                mainWidget = Column(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, top: 18),
                    child: Row(
                      children: [
                        Stack(children: <Widget>[
                          CircleAvatar(
                            child: Text(''),
                            radius: 40,
                            backgroundImage: NetworkImage(
                              snapshot.data['photoUrl'] != 'no_picture_upload'
                                  ? '${snapshot.data['photoUrl']}'
                                  : 'https://uploads.fixme.ng/originals/no_picture_upload',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          Positioned(
                            left: 55,
                            top: 50,
                            child: InkWell(
                              onTap: () => pickImage(
                                  source: ImageSource.gallery,
                                  context: context),
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Color(0xFFA40C85),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  FeatherIcons.camera,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  'Edit fullname',
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        '${snapshot.data['firstname']} ${snapshot.data['lastname']}',
                                        style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    _showEditNameModal(
                                        snapshot.data['firstname'],
                                        snapshot.data['lastname']);
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color(0xFFA40C85),
                                        ),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      FeatherIcons.edit3,
                                      size: 14,
                                      color: Color(0xFFA40C85),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Edit about',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          snapshot.data['about'] == null ||
                                                  snapshot.data['about'] == ''
                                              ? "No bio set"
                                              : '${snapshot.data['about']}',
                                          style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      _showAboutModal(
                                          '${snapshot.data['about']}');
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xFFA40C85),
                                          ),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        FeatherIcons.edit3,
                                        size: 14,
                                        color: Color(0xFFA40C85),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              }
            } else {
              mainWidget = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: Color(0xFF9B049B)),
                        child: CircularProgressIndicator()),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Loading',
                        style: TextStyle(
                            // letterSpacing: 4,
                            color: Color(0xFF333333),
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }
            return mainWidget;
          }),
    );
  }

  _showEditNameModal(firstname, lastname) {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    _firstnameController.text = firstname;
    _lastnameController.text = lastname;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Enter your name",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: Border.all(color: Color(0xFFF1F1FD)),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: TextFormField(
                      controller: _firstnameController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                      ],
                      decoration: InputDecoration.collapsed(
                        hintText: 'First Name',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: Border.all(color: Color(0xFFF1F1FD)),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: TextFormField(
                      controller: _lastnameController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                      ],
                      decoration: InputDecoration.collapsed(
                        hintText: 'Last Name',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100, minHeight: 34.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed: () async {
                          String firstname = _firstnameController.text;
                          String lastname = _lastnameController.text;
                          bool status = await network.editUserName(
                              firstname: firstname, lastname: lastname);
                          if (status) {
                            await data.storeData('firstName', '$firstname');
                            await data.storeData('lastName', '$lastname');
                            update(context);
                            network.initializeValues();
                            Navigator.of(context).pop();
                            _firstnameController.clear();
                            _lastnameController.clear();
                          }
                        },
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100, minHeight: 34.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                ]),
          ),
        );
      },
    );
  }

  _showAboutModal(bio) {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    _statusController.text = bio;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Edit About",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: Border.all(color: Color(0xFFF1F1FD)),
                        borderRadius: BorderRadius.all(Radius.circular(7))),
                    child: TextFormField(
                      controller: _statusController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                      ],
                      decoration: InputDecoration.collapsed(
                        hintText: 'Last Name',
                        hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100, minHeight: 34.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        disabledColor: Color(0x909B049B),
                        onPressed: () async {
                          String bio = _statusController.text;
                          bool status = await network.editUserBio(status: bio);
                          if (status) {
                            await data.storeData('about', '$bio');
                            update(context);
                            network.initializeValues();
                            Navigator.of(context).pop();
                            _statusController.clear();
                          }
                        },
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 100, minHeight: 34.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                ]),
          ),
        );
      },
    );
  }
}
