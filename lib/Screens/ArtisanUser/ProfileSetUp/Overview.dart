import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatefulWidget {
  final myPage;
  OverviewPage(this.myPage);
  @override
  OverviewPageState createState() => OverviewPageState();
}

class OverviewPageState extends State<OverviewPage> {
  final jobdescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var data =Provider.of<DataProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15),
              child: Text('${data.artisanVendorChoice == 'business'?"Enter your Business Description":"Proffessional Overview"}',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            TextFormField(
              onFieldSubmitted: (v){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              controller: jobdescriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              maxLength: 1000,
              onChanged: (value) {
                setState(() {
                  data.setOverView(value);
                });

              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF9B049B), width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF9B049B), width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF9B049B), width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 13),
                child: InkWell(
                    onTap: () {
                      widget.myPage.jumpToPage(2);
                    },
                    child: Text('Skip this step')),
              ),
            ),
            Spacer(),
    Consumer<DataProvider>(
    builder: (context, conData, child) {
    return Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(26)),
                child: FlatButton(
                  disabledColor: Color(0x909B049B),
                  onPressed: jobdescriptionController.text.isEmpty
                      ? null
                      : () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                          widget.myPage.jumpToPage(2);
                        },
                  color: Color(0xFF9B049B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(26)),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.3,
                          minHeight: 45.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Next",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );}),
          ],
        ),
      ),
    );
  }
}
