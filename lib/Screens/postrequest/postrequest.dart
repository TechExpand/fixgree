import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Services/postrequest_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'bottomnavbar.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  List categorylist = ['Category1', 'Category2', 'Category3'];
  String thevalue;
  var selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    PostRequestProvider postRequestProvider = Provider.of<PostRequestProvider>(context);
    WebServices webServices = Provider.of<WebServices>(context);
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          //title: Text(widget.title),
          actions: [
            IconButton(icon: Icon(Icons.close, color: Color(0xFF9B049B),), onPressed: (){
            Navigator.pop(context);}
            ),
            //TextField(),
            Expanded(
                child: Center(
              child: Text(
                'Post A Request',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9B049B)),
              ),
            ))
          ],
        ),
        body:
        postRequestProvider.loading ? Center(child: CircularProgressIndicator()) :
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: Color(0xFF9B049B),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 5, right: 5),
                    child: Column(
                      children: [
                        Text(
                          'How Does Your Request Work?',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.star, color: Colors.white),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    'We send your request to all artisan within your location.',
                                    style: TextStyle(color: Colors.white)),
                              )
                            ]),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.star, color: Colors.white),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    'Artisan will then send you their offers and you can choose who you would want to work with.',
                                    style: TextStyle(color: Colors.white)),
                              )
                            ]),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.star, color: Colors.white),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    'Once you have decided, you can contact them.',
                                    style: TextStyle(color: Colors.white)),
                              )
                            ]),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text('Got it'.toUpperCase(), style: TextStyle(color:Colors.white))),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Job Title'),
              SizedBox(height: 10),
              TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: postRequestProvider.jobtitleController,
                  decoration: InputDecoration(border: OutlineInputBorder())),
              SizedBox(height: 10),
              Text('Describe Your Request'),
              SizedBox(height: 10),
              TextFormField(
                  controller: postRequestProvider.jobdescriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  maxLength: 1000,
                  decoration: InputDecoration(border: OutlineInputBorder())),
              SizedBox(height: 10),
              Text('Job Address'),
              SizedBox(height: 10),
              TextFormField(
                controller: postRequestProvider.jobaddressController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(border: OutlineInputBorder())),
              SizedBox(height: 10),
              Text('Choose A Service'),
              SizedBox(height: 5),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: DropdownButton(
                    underline: SizedBox(),
                    hint: Text('Select a service'),
                    // dropdownColor: Colors.grey,
                    isExpanded: true,
                    elevation: 5,
                    style: TextStyle(color: Colors.black),
                    value: postRequestProvider.selectedService,
                    items: postRequestProvider.servicesList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Row(children: [
                              SizedBox(
                                width: 4,
                              ),
                              Icon(Icons.folder, color: Color(0xFF9B049B)),
                              SizedBox(width: 5),
                              Text('${e.service}'),
                            ]),
                          ),
                        )
                        .toList()
                        ,
                    onChanged: postRequestProvider.changeService
                    ),
              ),

              SizedBox(height: 15),
              Text("What's your budget? (Optional)"),
              SizedBox(height: 5),
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Row(
                    children: [
                      SizedBox(width: 3,),
                      //Icon(Icons.money_sharp, color: Color(0xFF9B049B)),
                      Text('Budget'),
                      VerticalDivider(),
                      Expanded(
                        child: TextFormField(
                          controller: postRequestProvider.amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: ('Amount'),
                              labelStyle: TextStyle(color: Color(0xFF9B049B))),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: 15),
              // MaterialButton(onPressed: _selectDate(context),),
              SizedBox(height: 15),

              GestureDetector(
                  onTap: () async {
                    postRequestProvider.postJob(context);
                  },
                  child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF9B049B),
                      borderRadius: BorderRadius.circular(15)),
                  height: 50,
                  child: Center(
                      child: Text(
                    'Submit Your Request',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
