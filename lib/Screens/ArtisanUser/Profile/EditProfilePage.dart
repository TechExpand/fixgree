import 'package:fixme/Model/service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  List<Services> result = [];
  Future<dynamic> userInfo;
  PickedFile selectedImage;
  final picker = ImagePicker();

  update(BuildContext context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    setState(() {
      userInfo = network.getUserInfo(network.userId);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    update(context);
    // var data = Provider.of<Utils>(context, listen: false);
    // var location = Provider.of<LocationService>(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(() {
              setState(() {});
            });
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
        ),
        title: Text('Edit profile',
            style: GoogleFonts.openSans(
                color: Colors.black87,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: userInfo,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 18, top: 18),
                      child: Row(
                        children: [
                          Container(
                            width: 200,
                            child: Stack(children: <Widget>[
                              CircleAvatar(
                                child: Text(''),
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  network.profilePicFileName ==
                                              'no_picture_upload' ||
                                          network.profilePicFileName == null
                                      ? 'https://uploads.fixme.ng/originals/no_picture_upload'
                                      : 'https://uploads.fixme.ng/originals/${network.profilePicFileName}',
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
                                    height: 28,
                                    width: 28,
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
                          ),
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
                                          '${snapshot.data['firstName']} ${snapshot.data['lastName']}',
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
                                      _editName(snapshot.data['firstName'],
                                          snapshot.data['lastName']);
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
                                      'Edit service area',
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
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '${snapshot.data['serviceArea']}'
                                                .toUpperCase(),
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
                                        _editService();
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Divider(),
                                Row(
                                  children: [
                                    Text(
                                      'Edit subservices',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 5,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      for (dynamic subService
                                          in snapshot.data['subServices'])
                                        Chip(
                                          backgroundColor: Color(0xFF9B049B)
                                              .withOpacity(0.5),
                                          deleteIcon: Icon(
                                            FeatherIcons.x,
                                            size: 15,
                                          ),
                                          onDeleted: () {},
                                          deleteIconColor: Colors.white,
                                          label: Text(
                                            subService['subservice'].toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      Container(
                                        height: 32,
                                        width: 32,
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Color(0xFFA40C85),
                                            ),
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          FeatherIcons.plus,
                                          size: 16,
                                          color: Color(0xFFA40C85),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            snapshot.data['bio'] == null ||
                                                    snapshot.data['bio'] == ''
                                                ? "No bio set"
                                                : '${snapshot.data['bio']}',
                                            textAlign: TextAlign.start,
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
                                        _editAbout('${snapshot.data['bio']}');
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Divider(),
                                Row(
                                  children: [
                                    Text(
                                      'Edit address',
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
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            '${snapshot.data['businessAddress'].toString().isEmpty ? snapshot.data['address'] : snapshot.data['businessAddress']}',
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
                                        _editAddress(
                                            '${snapshot.data['businessAddress'].toString().isEmpty ? snapshot.data['address'] : snapshot.data['businessAddress']}');
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
                  ])
                : Center(
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
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
          }),
    );
  }

  void _editName(firstname, lastname) {
    final _controller = TextEditingController();
    final _controller2 = TextEditingController();
    _controller.text = firstname;
    _controller2.text = lastname;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 220.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Text(
                        "Edit fullname",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
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
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: 'First Name',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: TextField(
                          controller: _controller2,
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
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
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () async {
                              await network.updateFullName(
                                  _controller.text, _controller2.text);
                              update(context);
                              // setState(() {});
                              Navigator.pop(context);
                            },
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                    ],
                  )));
        });
  }

  _editService() {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);

    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 190.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Text(
                        "Edit service area",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            result = postRequestProvider.allservicesList;
                            dialogPage(context);
                          },
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            enabled: false,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration.collapsed(
                              hintText: postRequestProvider.selecteService ==
                                      null
                                  ? 'Select Service'
                                  : postRequestProvider.selecteService.service,
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38),
                            ),
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
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
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () async {
                              network.updateService(
                                  postRequestProvider.selecteService.sn);
                              update(context);
                              Navigator.pop(context);
                            },
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                    ],
                  )));
        });
  }

  _editAbout(bio) {
    final _controller = TextEditingController();
    _controller.text = bio;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 180.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Text(
                        "Edit about",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: 'About',
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
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
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () async {
                              network.updateBio(_controller.text);
                              update(context);
                              Navigator.pop(context);
                            },
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                    ],
                  )));
        });
  }

  _editAddress(address) {
    final _controller = TextEditingController();
    _controller.text = address;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return new Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: 180.0,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      Text(
                        "Edit address",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: 'address',
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
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
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                              border: Border.all(
                                  color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () {},
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 100, minHeight: 34.0),
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
                    ],
                  )));
        });
  }

  dialogPage(ctx) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return AlertDialog(
                title: TextFormField(
                  onChanged: (value) {
                    setStates(() {
                      searchServices(value);
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Search Services',
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(new Radius.circular(50.0)),
                  ),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 500,
                          child: ListView.builder(
                            itemCount: result == null ? 0 : result.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  postRequestProvider
                                      .changeSelectedService(result[index]);
                                },
                                child: ListTile(
                                  title: Text('${result[index].service}'),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((v) {
      setState(() {});
    });
  }

  void searchServices(userInputValue) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    result = postRequestProvider.allservicesList
        .where((service) => service.service
            .toLowerCase()
            .contains(userInputValue.toLowerCase()))
        .toList();
  }
}
