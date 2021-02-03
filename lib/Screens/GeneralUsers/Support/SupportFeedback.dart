import 'package:fixme/Screens/GeneralUsers/Support/Providers/SupportProvider.dart';
import 'package:fixme/Screens/GeneralUsers/Support/SupportChat.dart';
import 'package:fixme/Screens/GeneralUsers/Support/SupportFeedbackSent.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Widgets/customdropdownbutton.dart';
import 'package:provider/provider.dart';

class SupportFeedback extends StatefulWidget {
  SupportFeedback({Key key}) : super(key: key);

  @override
  _SupportFeedbackState createState() => _SupportFeedbackState();
}

class _SupportFeedbackState extends State<SupportFeedback> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> _feedback = [
    'Something is wrong with your request',
    'Something is wrong with the payment',
    'Delivery was delayed',
    'I didn’t get my item',
    'Other Feedback'
  ];

  String username;

  getUserDetails(BuildContext buildContext) async {
    var data = Provider.of<Utils>(buildContext, listen: false);
    String firstname = await data.getData('firstName');
    String lastname = await data.getData('lastName');

    username =
        firstname.capitalizeFirstOfEach + ' ' + lastname.capitalizeFirstOfEach;
  }

  @override
  Widget build(BuildContext context) {
    getUserDetails(context);
    var network = Provider.of<WebServices>(context, listen: false);
    return ChangeNotifierProvider<SupportProvider>(
        create: (_) => SupportProvider(),
        builder: (context, _) {
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
                ),
                actions: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SupportChat();
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
                        child: Text('Chat with us',
                            style: TextStyle(
                                color: Color(0xFF9B049B),
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              backgroundColor: Colors.white,
              body:
                  Consumer<SupportProvider>(builder: (context, model, widget) {
                return ListView(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        height: 140,
                        margin: const EdgeInsets.only(
                            top: 20, right: 5, bottom: 20),
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/fixme.png'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Help us improve',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        children: [
                          Text(
                              'Please select a topic below and let us know your concern',
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 15),
                        margin: const EdgeInsets.only(bottom: 3, top: 15),
                        decoration: BoxDecoration(
                            color: Color(0xFF9B049B),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFFF1F1FD).withOpacity(0.5),
                                  blurRadius: 10.0,
                                  offset: Offset(0.3, 4.0))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 0.00006146
                            Expanded(
                                child: CustomDropdownButton(
                              dropdownColor: Color(0xFFF6F6F6),
                              underline: Container(),
                              icon: Container(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              hint: Text(
                                'Select topic',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              value: model.getSelectedFeedback ?? null,
                              onChanged: (newValue) {
                                model.setSelectedFeedback = newValue;
                              },
                              elevation: 0,
                              items: _feedback.map((location) {
                                return CustomDropdownMenuItem(
                                  child: new Text(location),
                                  value: location,
                                );
                              }).toList(),
                            )),
                            Padding(
                              padding: const EdgeInsets.only(right: 13),
                              child: Icon(
                                FeatherIcons.chevronDown,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 17, top: 10),
                        margin: const EdgeInsets.only(bottom: 6, top: 10),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(color: Color(0xFFF1F1FD)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFFF1F1FD).withOpacity(0.5),
                                  blurRadius: 10.0,
                                  offset: Offset(0.3, 4.0))
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFormField(
                                autofocus: false,
                                maxLines: 9,
                                enabled: model.getIsFieldEnabled,
                                onChanged: (val) {
                                  model.setOtherFeedback = val;
                                },
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF270F33),
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration.collapsed(
                                  hintText: '',
                                  focusColor: Color(0xFF2B1137),
                                  fillColor: Color(0xFF2B1137),
                                  hoverColor: Color(0xFF2B1137),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      model.getSendStatus
                          ? Container(
                              height: 45,
                              margin: const EdgeInsets.only(top: 25),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: model.getIsButtonEnabled
                                    ? Color(0xFF9B049B)
                                    : Color(0xFFF6F6F6),
                              ),
                              child: new FlatButton(
                                padding: EdgeInsets.all(10),
                                onPressed: () async {
                                  if (model.getIsButtonEnabled) {
                                    model.setSendStatus = false;
                                    print(model.getIsFieldEnabled
                                        ? model.getOtherFeedback
                                        : model.getSelectedFeedback+': The message');
                                    bool status =
                                        await network.sendSupportRequest(
                                            topic:
                                                'Support Feedback - $username',
                                            message: model.getIsFieldEnabled
                                                ? model.getOtherFeedback
                                                : model.getSelectedFeedback);
                                    if (status) {
                                      model.setSendStatus = true;
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) {
                                            return SupportFeedbackSent();
                                          },
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Some error occured')));
                                    }
                                  } else {}
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 7, right: 7),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: model.getIsButtonEnabled
                                                ? Colors.white
                                                : Color(0xFF777777),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin:
                                  const EdgeInsets.only(top: 25, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                          accentColor: Color(0xFF9B049B)),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ]);
              }));
        });
  }
}
