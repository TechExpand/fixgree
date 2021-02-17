import 'package:fixme/Screens/GeneralUsers/Chat/ChatFiles.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopUpMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String idUser;
  final user;
  final popData;

  PopUpMenu({
    this.user,
    this.popData,
    @required this.idUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);

    return PopupMenuButton(
        offset: const Offset(0, 80),
        elevation: 5,
        icon: Icon(
          Icons.more_vert,
          size: 28,
        ),
        itemBuilder: (context) => [
              user.project_owner_user_id.toString() !=
                          network.userId.toString() ||
                      user.project_owner_user_id == null
                  ? null
                  : PopupMenuItem(
                      value: 1,
                      child: InkWell(
                        onTap: () {
                          dialogPage(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('Initiate Project'),
                        ),
                      )),
              PopupMenuItem(
                  value: 2,
                  child: InkWell(
                    onTap: () {
                      FirebaseApi.clearMessage(
                          idUser,
                          '${network.firstName}-${user.name}',
                          '${user.name}-${network.firstName}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Clear Message'),
                    ),
                  )),
              PopupMenuItem(
                  value: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ChatFiles(idUser: user.idUser, user: user);
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
            ]);
  }

  dialogPage(ctx) {
    var network = Provider.of<WebServices>(ctx, listen: false);
    final _controller = TextEditingController();
    showDialog(
        context: ctx,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return AlertDialog(
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Budget',
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
                content: network.loginPopState
                    ? Container(
                        height: 30,
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF9B049B)),
                          ),
                        ),
                      )
                    : Container(
                        width: 125,
                        height: 45.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                        child: FlatButton(
                          disabledColor: Color(0x909B049B),
                          onPressed: () {
                            network.loginPopSetState();
                            setStates(() {});
//                   network.initiateProject(pop_data.project_owner_user_id, pop_data.bid_id,
//                       pop_data.project_id, pop_data.service_id, _controller.text, context);
                            network
                                .initiateProject(
                                    user.project_owner_user_id,
                                    user.bid_id,
                                    user.job_id,
                                    user.service_id,
                                    _controller.text,
                                    context,
                                    setStates)
                                .then((v) {
                              FirebaseApi.clearJobBids(
                                user.project_owner_user_id,
                              );
                            });
                          },
                          color: Color(0xFF9B049B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 125, minHeight: 45.0),
                              alignment: Alignment.center,
                              child: Text(
                                "INITIATE",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            },
          );
        });
  }
}
