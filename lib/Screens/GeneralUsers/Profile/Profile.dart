import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _statusController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  PickedFile selectedImage;
  final picker = ImagePicker();
  String firstname1;
  String lastname1;
  String bio1;

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

    firstname1 = firstname;
    lastname1 = lastname;
    bio1 = about;

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
                mainWidget = Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Stack(children: <Widget>[
                        snapshot.data['photoUrl'] != 'no_picture_upload'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  snapshot.data['photoUrl'],
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.account_circle,
                                size: 160, color: Colors.black38),
                        Positioned(
                          left: 107,
                          top: 103,
                          child: InkWell(
                            onTap: () => pickImage(
                                source: ImageSource.gallery, context: context),
                            child: Container(
                              height: 43,
                              width: 43,
                              decoration: BoxDecoration(
                                  color: Color(0xFFA40C85),
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 21,
                              ),
                            ),
                          ),
                        ),
                      ]),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${snapshot.data['firstname']} ${snapshot.data['lastname']}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                              Text(
                                "This name will be visible to your Fixme contacts.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
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
                          onTap: () => _showEditNameModal(),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data['about'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
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
                          onTap: () => _showAboutModal(),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data['phone'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
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

  void _showAboutModal() {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    _statusController.text = bio1;
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
            child: Form(
              key: _formKey2,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Add About",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.88,
                          height: 33,
                          child: TextFormField(
                            controller: _statusController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            style: TextStyle(fontSize: 18),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusColor: Colors.black,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
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
                        onTap: () async {
                          if (_formKey2.currentState.validate()) {
                            String bio = _statusController.text;
                            bool status =
                                await network.editUserBio(status: bio);
                            if (status) {
                              await data.storeData('about', '$bio');
                              update(context);
                              network.initializeValues();
                              Navigator.of(context).pop();
                              _statusController.clear();
                            }
                          }
                        },
                      )
                    ])
                  ]),
            ),
          ),
        );
      },
    );
  }

  void _showEditNameModal() {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    _firstnameController.text = firstname1;
    _lastnameController.text = lastname1;
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
            child: Form(
              key: _formKey1,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Enter your name",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.88,
                          height: 33,
                          child: TextFormField(
                            controller: _firstnameController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Firstname',
                              focusColor: Colors.black,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.88,
                          height: 33,
                          child: TextFormField(
                            controller: _lastnameController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Lastname',
                              focusColor: Colors.black,
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
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
                        onTap: () async {
                          if (_formKey1.currentState.validate()) {
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
                          }
                        },
                      )
                    ])
                  ]),
            ),
          ),
        );
      },
    );
  }
}
