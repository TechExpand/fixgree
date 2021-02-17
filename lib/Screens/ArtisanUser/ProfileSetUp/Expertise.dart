import 'package:fixme/Model/service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Widgets/Dialog.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:provider/provider.dart';

class ExpertisePage extends StatefulWidget {
  var myPage;
  ExpertisePage(this.myPage);
  @override
  _ExpertisePageState createState() => _ExpertisePageState();
}

class _ExpertisePageState extends State<ExpertisePage> {
  List<Services> result = [];
  List<Widget> chip = [];

  @override
  Widget build(BuildContext context) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    var data = Provider.of<DataProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.only(right: 24, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text('Tell us about the work you do',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13.0, bottom: 13),
            child: Text('What are the main services you offer?'),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              result = postRequestProvider.allservicesList;
              DialogPage(context);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              width: MediaQuery.of(context).size.width / 0.2,
              height: 50,
              child: TextFormField(
                enabled: false,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black38),
                  labelText: postRequestProvider.selecteService == null
                      ? 'Category'
                      : postRequestProvider.selecteService.service,
                  suffixIcon: Icon(Icons.arrow_downward, color: Colors.black38),
                  disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 13),
            child: Text('What skills do you offer clients?'),
          ),
          InkWell(
            onTap: chip.length >= 5
                ? null
                : () {
                    result = postRequestProvider.allservicesList;

                    DialogPageAdd(context);
                  },
            child: Container(
              width: MediaQuery.of(context).size.width / 0.2,
              height: 50,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.add, color: Color(0xFF9B049B)),
                  labelStyle: TextStyle(color: Color(0xFF9B049B)),
                  labelText: 'Add',
                  disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFF9B049B), width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 13),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Text('Enter at least 1 skill')),
          ),
          Wrap(
            children: chip,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  chip.clear();
                  data.setclrSubCat();
                  setState(() {});
                },
                child: Text('Clear All',
                    style: TextStyle(
                        color: Color(0xFF9B049B),
                        fontWeight: FontWeight.bold))),
          ),
          Spacer(),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(26)),
              child: FlatButton(
                disabledColor: Color(0x909B049B),
                onPressed:
                    chip.isEmpty || postRequestProvider.selecteService == null
                        ? null
                        : () {
                            widget.myPage.jumpToPage(1);
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
          ),
        ],
      ),
    );
  }

  Widget DialogPage(ctx) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    showDialog(
      context: context,
      child: StatefulBuilder(
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
      ),
    ).then((v) {
      setState(() {});
    });
  }

  Widget DialogPageAdd(ctx) {
    PostRequestProvider postRequestProvider =
        Provider.of<PostRequestProvider>(context, listen: false);
    var data = Provider.of<DataProvider>(context, listen: false);
    showDialog(
      context: context,
      child: StatefulBuilder(
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

                              data.setSubCat(result[index].service);

                              chip.add(
                                InkWell(
                                  onTap: () {
                                    // data.setdelSubCat(result[index].service);
                                    //  chip.remove(0);
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Chip(
                                        label:
                                            Text('${result[index].service}')),
                                  ),
                                ),
                              );
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
      ),
    ).then((v) {
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
