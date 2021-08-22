import 'package:fixme/Screens/GeneralUsers/Profile/EditProfile.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class ProfileNew extends StatefulWidget {
  @override
  _ProfileNewState createState() => _ProfileNewState();
}

class _ProfileNewState extends State<ProfileNew> {
  String firstname1;
  String lastname1;
  String bio1;

  Future<Map> user;

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

    Map userDetails = {
      'firstname': firstname,
      'lastname': lastname,
      'about': about,
      'phone': phone,
      'address': address,
      'photoUrl': 'https://uploads.fixme.ng/thumbnails/$photoUrl'
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FeatherIcons.moreHorizontal, color: Color(0xFF9B049B)),
          ),
        ],
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
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                             strokeWidth: 2,
                                              backgroundColor: Colors.white,
    // valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
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
                                  : 'https://uploads.fixme.ng/thumbnails/no_picture_upload',
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white,
                          ),
                          Positioned(
                            left: 63,
                            top: 55,
                            child: Container(
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFB8333),
                                  shape: BoxShape.circle),
                              // child: Icon(
                              //   Icons.check,
                              //   size: 11,
                              //   color: Colors.white,
                              // ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      '${snapshot.data['firstname']} ${snapshot.data['lastname']}'
                                          .capitalizeFirstOfEach,
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFE9E9E9), width: 1),
                                    borderRadius: BorderRadius.circular(5)),
                                child: FlatButton(
                                  disabledColor: Color(0x909B049B),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          return EditProfile();
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
                                          maxWidth: 100, minHeight: 35.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Edit profile",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
                                  'About',
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Wrap(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data['about']}',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
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
                                    'Phone',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Wrap(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${snapshot.data['phone']}',
                                      style: TextStyle(
                                          color: Color(0xFF333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
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
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                           strokeWidth: 2,
                                              backgroundColor: Colors.white,
    // valueColor: new AlwaysStoppedAnimation<Color>(color: Color(0xFF9B049B)),
)),
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
}
