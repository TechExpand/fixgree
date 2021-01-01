import 'package:fixme/Screens/Chat/ChatFiles.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpMenu extends StatelessWidget {
  final String idUser;
  final   user;
  const PopUpMenu({
    this.user,
    @required this.idUser,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
  var network = Provider.of<WebServices>(context, listen: false);
    return PopupMenuButton(
        offset: const Offset(0,80),
      elevation: 5,
      icon: Icon(
        Icons.more_vert,
        size: 28,
      ),

        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child:  Text('View contact'),
                  )),
//              PopupMenuItem(
//                  value: 2,
//                  child:  InkWell(
//                    onTap: (user.block??false)?(){
//                      print('unblock');
//                      FirebaseApi.unblockUser(network.mobile_device_token);
//                    }:(){
//                      print('block');
//                      FirebaseApi.blockUser(network.mobile_device_token);
//                    },
//                     child: Padding(
//              padding: const EdgeInsets.all(8),
//              child: Text((user.block??false)?'Unblock':'Block'),
//              ),
//                  )),
              PopupMenuItem(
                  value: 3,
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return ChatFiles(idUser: user.idUser, user: user);
                          },
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Media, links, and docs'),
                    ),
                  )),
              PopupMenuItem(
                  value: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Mute notifications'),
                  )),
            ]);
  }
}
