import 'package:fixme/Screens/GeneralUsers/Support/Providers/SupportProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class SupportFeedbackSent extends StatefulWidget {
  SupportFeedbackSent({Key key}) : super(key: key);

  @override
  _SupportFeedbackSentState createState() => _SupportFeedbackSentState();
}

class _SupportFeedbackSentState extends State<SupportFeedbackSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(FeatherIcons.x, color: Color(0xFF777777)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
            padding: const EdgeInsets.only(left: 30, right: 30),
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: 140,
                margin: const EdgeInsets.only(top: 20, right: 5, bottom: 20),
                alignment: Alignment.center,
                child: Image.asset('assets/images/fixme.png'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Thank you!',
                      style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w600))
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Wrap(
                  children: [
                    Text(
                        'Thank you for sharing your thoughts, We appreciate your feedback!',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w400))
                  ],
                ),
              ),
            ]));
  }
}
