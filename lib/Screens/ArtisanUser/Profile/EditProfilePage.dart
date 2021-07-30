import 'dart:io';

import 'package:fixme/Model/service.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ArtisanProvider.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Widgets/photoView.dart';
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
  File selectedImage;

  Future<dynamic> cataloguePhotos;
  Future<dynamic> products;

  getCataloguePhotos(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
        Provider.of<ArtisanProvider>(context, listen: false);
    cataloguePhotos = network.getServiceImage(network.userId, network.userId);
    cataloguePhotos.then((data) {
      int catalogueCount = data.length;
      artisanProvider.setCatalogueCount = catalogueCount;
    });
  }

  getProducts(context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    final artisanProvider =
        Provider.of<ArtisanProvider>(context, listen: false);
    products = network.getProductImage(network.userId, network.userId);
    products.then((data) {
      int productCount = data.length;
      artisanProvider.setProductCount = productCount;
    });
  }

  updateProduct(BuildContext context)async{
    var network = Provider.of<WebServices>(context, listen: false);
    setState(() {
      products = network.getProductImage(network.userId, network.userId);
    });
  }

  update(BuildContext context) async {
    var network = Provider.of<WebServices>(context, listen: false);
    setState(() {
      userInfo = network.getUserInfo(network.userId);
    });
  }

  void pickImage({@required ImageSource source, context}) async {
    var network = Provider.of<WebServices>(context, listen: false);
    var data = Provider.of<Utils>(context, listen: false);
    var image = await ImagePicker.pickImage(source: source);
    setState(() => selectedImage = image);

    String imageName = await network.uploadProfilePhoto(
      path: selectedImage.path,
    );

    data.storeData('profile_pic_file_name', imageName);
    network.initializeValues();
    update(context);
  }

  @override
  void initState() {
    super.initState();
    getCataloguePhotos(context);
    getProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    update(context);
    getCataloguePhotos(context);
    // var data = Provider.of<Utils>(context, listen: false);
    // var location = Provider.of<LocationService>(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9B049B),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(() {
              setState(() {});
            });
          },
          icon: Icon(FeatherIcons.arrowLeft, color: Colors.white),
        ),
        title: Text('Edit profile',
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                height: 1.4,
                fontWeight: FontWeight.w600)),
        elevation: 3,
      ),
      body: FutureBuilder(
          future: userInfo,
          builder: (context, snapshot) {
            print(network.userId);
            print(network.bearer);
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
                                  onTap: () async {
                                    pickImage(
                                        source: ImageSource.gallery,
                                        context: context);
                                  },
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
                          Column(
                            children: [
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Business Name',
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
                                          '${snapshot.data['businessName']}',
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
                                      _businessName(snapshot.data['businessName']);
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
                                          onDeleted: () {
                                            network.deleteSubService(subService['id']);
                                            update(context);
                                            update(context);
                                          },
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
                                        child: IconButton(
                                        icon:Icon(  FeatherIcons.plus,
                                          size: 16,
                                          color: Color(0xFFA40C85),
                                        ),onPressed: (){
                                          _addSubService();
                                        },),
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
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              snapshot.data['role'] == 'artisan'
                                  ? Text('Catalogues',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600))
                                  : Text('Products',
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                              InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: snapshot.data['role'] == 'artisan'
                                    ? () {
                                        _AddCatalogue();
                                      }
                                    : () {
                                        _AddProduct();
                                      },
                                child: Container(
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
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: snapshot.data['role'] == 'artisan'
                                ? FutureBuilder(
                                    future: cataloguePhotos,
                                    builder: (context, snapshot) {
                                      Widget mainWidget;
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.data == null ||
                                            snapshot.data.length == 0) {
                                          mainWidget = Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('No images',
                                                    style: TextStyle(
                                                        // letterSpacing: 4,
                                                        color:
                                                            Color(0xFF333333),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          );
                                        } else {
                                          mainWidget = Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5,
                                                  left: 5,
                                                  right: 5,
                                                  top: 5),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: snapshot.data == null
                                                    ? 0
                                                    : snapshot.data.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 5,
                                                  mainAxisSpacing: 5,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) {
                                                            return PhotoView(
                                                              'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                              snapshot.data[
                                                                      index][
                                                                  'imageFileName'],
                                                            );
                                                          },
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: child,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag: snapshot.data[index]
                                                          ['imageFileName'],
                                                      child: Container(
                                                          width: 200,
                                                          child: Image.network(
                                                            'https://uploads.fixme.ng/originals/${snapshot.data[index]['imageFileName']}',
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  );
                                                },
                                              ));
                                        }
                                      } else {
                                        mainWidget = Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          accentColor: Color(
                                                              0xFF9B049B)),
                                                  child:
                                                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),

 strokeWidth: 2,
                                              backgroundColor: Colors.white,
)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('Loading',
                                                  style: TextStyle(
                                                      // letterSpacing: 4,
                                                      color: Color(0xFF333333),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ],
                                          ),
                                        );
                                      }
                                      return mainWidget;
                                    })
                                : futureProduct()
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
                            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                               strokeWidth: 2,
                                              backgroundColor: Colors.white,

)),
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
          return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
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
                    )),
          );
        });
  }



  futureProduct(){
   return FutureBuilder(
        future: products,
        builder: (context, snapshot) {
          Widget mainWidget;
          if (snapshot.connectionState ==
              ConnectionState.done) {
            if (snapshot.data == null ||
                snapshot.data.length == 0) {
              mainWidget = Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    Text('No products',
                        style: TextStyle(
                          // letterSpacing: 4,
                            color:
                            Color(0xFF333333),
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w600)),
                  ],
                ),
              );
            } else {
              mainWidget = Container(
                  margin: const EdgeInsets.only(
                      bottom: 30.0,
                      left: 8,
                      right: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data == null
                        ? 0
                        : snapshot.data.length,
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            10),
                        child: Container(
                          child: ListTile(
                            trailing: Container(
                              height: 32,
                              width: 32,
                              margin:
                              const EdgeInsets
                                  .only(
                                  top: 10),
                              decoration:
                              BoxDecoration(
                                  border: Border
                                      .all(
                                    width: 1,
                                    color: Color(
                                        0xFFA40C85),
                                  ),
                                  shape: BoxShape
                                      .circle),
                              child: IconButton(
                                  onPressed: () {
                                    Utils data = Provider.of<Utils>(context, listen: false);
                                    data
                                        .selectProductImagetoNull();
                                    _editProduct(
                                        snapshot.data[index]['product_name'],
                                        snapshot.data[index]['price'].toString(),
                                        snapshot.data[index]['description'],
                                      snapshot.data[index]['productImages'][0]['productId'],
                                        snapshot.data[index]['productImages'][0]['imageFileName']
                                    );
                                  },
                                  icon: Icon(
                                    FeatherIcons
                                        .edit3,
                                    size: 14,
                                    color: Color(
                                        0xFFA40C85),
                                  )),
                            ),
                            onTap: () {
                              _viewProduct(
                                  data: snapshot
                                      .data[index]);
                            },
                            contentPadding:
                            const EdgeInsets
                                .only(left: 0),
                            leading: CircleAvatar(
                              child: Text(''),
                              radius: 40,
                              backgroundImage:
                              NetworkImage(snapshot.data[index]['productImages'].isNotEmpty?
                              "https://uploads.fixme.ng/originals/${snapshot.data[index]['productImages'][0]['imageFileName']}":'',
                              ),
                              foregroundColor:
                              Colors.white,
                              backgroundColor:
                              Colors.white,
                            ),
                            title: Text(
                                "${snapshot.data[index]['product_name']}"
                                    .capitalizeFirstOfEach,
                                style: TextStyle(
                                    color: Colors
                                        .black)),
                            subtitle: RichText(
                              text: TextSpan(
                                text: '\u{20A6} ',
                                style: TextStyle(
                                    fontFamily:
                                    'Roboto',
                                    color: Colors
                                        .green,
                                    fontWeight:
                                    FontWeight
                                        .bold),
                                children: <
                                    TextSpan>[
                                  TextSpan(
                                      text:
                                      "${snapshot.data[index]['price']}",
                                      style: GoogleFonts.poppins(
                                          color: Colors
                                              .green,
                                          fontWeight:
                                          FontWeight
                                              .bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
            }
          } else {
            mainWidget = Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Theme(
                      data: Theme.of(context)
                          .copyWith(
                          accentColor: Color(
                              0xFF9B049B)),
                      child:
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                         strokeWidth: 2,
                                              backgroundColor: Colors.white,

)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Loading',
                      style: TextStyle(
                        // letterSpacing: 4,
                          color: Color(0xFF333333),
                          fontSize: 18,
                          fontWeight:
                          FontWeight.w600)),
                ],
              ),
            );
          }
          return mainWidget;
        });
  }


  void _businessName(businessName) {
    final _controller = TextEditingController();
    _controller.text = businessName;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
                height: 160.0,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: Colors.transparent,
                child: ListView(
                  children: [
                    Text(
                      "Edit Business Name",
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
                          hintText: 'Business Name',
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
                            await network.updateBizName(
                                _controller.text);
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
                )),
          );
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
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: StatefulBuilder(
              builder: (context, setState) {
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
                                  dialogPage(context).then((v) {
                                    setState(() {
                                      print('done');
                                    });
                                  });
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
              }
            ),
          );
        });
  }







  _addSubService() {
    PostRequestProvider postRequestProvider =
    Provider.of<PostRequestProvider>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new StatefulBuilder(
                builder: (context, setState) {
                  return new Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    height: 190.0,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    color: Colors.transparent,
                    child: ListView(
                      children: [
                        Text(
                          "Add Subservice area",
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
                              dialogPage(context).then((v) {
                                setState(() {
                                  print('done');
                                });
                              });
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
                                network.addSubService(
                                    postRequestProvider.selecteService.service);
                                Navigator.pop(context);
                                setState((){
                                  update(context);
                                });
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
                    )));}),
          );
        });
  }







  _editAbout(bio) {
    final _controller = TextEditingController();
    _controller.text = bio;
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
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
                    )),
          );
        });
  }

  void _AddProduct() {
    DataProvider datas = Provider.of<DataProvider>(context, listen: false);
    Utils data = Provider.of<Utils>(context, listen: false);
    final _controller = TextEditingController();
    final _controller1 = TextEditingController();
    final _controller2 = TextEditingController();
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new StatefulBuilder(builder: (context, setStat) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.19),
                      Text(
                        "Product Name",
                        style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                            hintText: 'Product Name',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Product Price",
                        style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Price',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Product Description",
                        style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                          controller: _controller2,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Description',
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 100, // card height
                          child: data.selectedImage2 == null
                              ? Text('No Image Selected')
                              : Container(
                                  width: 100,
                                  child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image.file(
                                        File(
                                          data.selectedImage2.path,
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(26)),
                            child: FlatButton(
                              disabledColor: Color(0xFF9B049B),
                              onPressed: () {
                                data
                                    .selectimage2(source: ImageSource.gallery)
                                    .then((value) {
                                  setStat(() {
                                    print('done');
                                  }
                                  );
                                });
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
                                    "Select/Upload Product Photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                              border:
                                  Border.all(color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () {

                              network
                                  .addProductCatalog(
                                context: context,
                                bio: _controller2.text.toString(),
                                productName: _controller.text.toString(),
                                price: _controller1.text.toString(),
                                path: data.selectedImage2.path,
                              );
                              updateProduct(context);
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
                  ));
            }),
          );
        });
  }




  void _editProduct(name, price, description, productID, productImage) {
    DataProvider datas = Provider.of<DataProvider>(context, listen: false);
    Utils data = Provider.of<Utils>(context, listen: false);
    final _controller = TextEditingController();
    final _controller1 = TextEditingController();
    final _controller2 = TextEditingController();
      _controller.text = name;
    _controller1.text = price;
    _controller2.text = description;
    var network = Provider.of<WebServices>(context, listen: false);


    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new StatefulBuilder(builder: (context, setStat) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.19),
                      Text(
                        "Product Name",
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                            hintText: 'Product Name',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Product Price",
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Price',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Product Description",
                        style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                          controller: _controller2,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Product Description',
                            hintStyle:
                            TextStyle(fontSize: 16, color: Colors.black38),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 100, // card height
                          child: data.ediproductImage == null
                              ? Container(
                            width: 100,
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)),
                                child: Image.network(
                                  'https://uploads.fixme.ng/originals/${productImage}',
                                  fit: BoxFit.cover,
                                )),
                          )
                              : Container(
                            width: 100,
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)),
                                child: Image.file(
                                  File(
                                    data.ediproductImage.path,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(26)),
                            child: FlatButton(
                              disabledColor:Colors.black54,
                              onPressed: () {
                                data
                                    .selectProductImagetoNull();
                                setStat(() {});
                              },
                              color: Colors.black54,
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
                                    "Back to previous image",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(26)),
                            child: FlatButton(
                              disabledColor: Colors.black54,
                              onPressed: () {
                                data
                                    .selectProductImage(source: ImageSource.gallery)
                                    .then((value) {
                                  setStat(() {});
                                });
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
                                    "Select/Upload Product Photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                              border:
                              Border.all(color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () {
                              network
                                  .editProduct(
                                productID: productID,
                                description: _controller2.text.toString(),
                                name: _controller.text.toString(),
                                price: _controller1.text.toString(),
                              ).then((value) {
                                data.ediproductImage ==null?null:network
                                    .editProductPic(
                                    name: _controller.text.toString(),
                                  path: data.ediproductImage.path ,
                                  productID: productID,
                                ).then((value){
                                  updateProduct(context);
                                  Navigator.pop(context);
                                });
                              });
                              data.ediproductImage ==null?updateProduct(context):null;
                              data.ediproductImage ==null? Navigator.pop(context):null;
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
                  ));
            }),
          );
        });
  }





  void _AddCatalogue() {
    DataProvider datas = Provider.of<DataProvider>(context, listen: false);
    Utils data = Provider.of<Utils>(context, listen: false);
    var network = Provider.of<WebServices>(context, listen: false);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: new StatefulBuilder(builder: (context, setStat) {
              return Container(
                height: 300,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 100, // card height
                          child: data.selectedImage2 == null
                              ? Text('No Image Selected')
                              : Container(
                                  width: 100,
                                  child: Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image.file(
                                        File(
                                          data.selectedImage2.path,
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(26)),
                            child: FlatButton(
                              disabledColor: Color(0xFF9B049B),
                              onPressed: () {
                                data
                                    .selectimage2(source: ImageSource.gallery)
                                    .then((value) {
                                  setStat(() {});
                                });
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
                                    "Select/Upload Service Photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
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
                              border:
                                  Border.all(color: Color(0xFFE9E9E9), width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: FlatButton(
                            disabledColor: Color(0x909B049B),
                            onPressed: () {
                              Navigator.pop(context);
                              network.addCatalog(
                                context,
                                path: data.selectedImage2.path,
                                uploadType: 'servicePicture',
                              ).then((value) {
                                setState(() {
                                  print(value);
                                });
                              });
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
                  ));
            }),
          );
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
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
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
                              onPressed: () async {
                                network.updateAddress(_controller.text);
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
                    )),
          );
        });
  }

  dialogPage(ctx) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
   return showDialog(
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
        });
  }

  _viewProduct({data}) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Container(
              height: 335.0,
              padding: EdgeInsets.only(
                top: 10,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  )),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                      ),
                    ],
                  ),
                  Container(
                    color: Color(0xFFF0F0F0),
                    child: Row(
                      children: [
                        for (dynamic item in data['productImages'])
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.all(8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      'https://uploads.fixme.ng/originals/${item['imageFileName']}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("${data['description']}", style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Product name",
                        style:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${data['product_name']}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Product amount",
                        style:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '\u{20A6} ',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: "${data['price']}",
                                style: GoogleFonts.poppins(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
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
