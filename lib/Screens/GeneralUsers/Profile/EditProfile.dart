import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
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
    );
  }
}
