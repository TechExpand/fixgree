import 'package:fixme/Services/postrequest_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DescribePage extends StatefulWidget {

  @override
  DescribePageState createState() => DescribePageState();
}

class DescribePageState extends State<DescribePage> {


  final jobdescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    PostRequestProvider postRequestProvider = Provider.of<PostRequestProvider>(context);
    var data = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon:Icon(Icons.keyboard_backspace, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
            'Post A Request', style:TextStyle(color:Colors.black)
        ),

      ),
      body: Container(
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top:15.0, bottom: 15),
              child: Text('Describe your request(Optional)', style: TextStyle(fontWeight: FontWeight.w500)),
            ),

            TextFormField(
              controller: jobdescriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              maxLength: 1000,
              onChanged: (value){
                data.setDescription(value);
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
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
            SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: postRequestProvider.loading?CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),):Container(

                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(26)),
                child: FlatButton(
                  onPressed:() {
                    postRequestProvider.postJob(context);
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
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
                          maxWidth: MediaQuery.of(context).size.width / 1.1,
                          minHeight: 45.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Post",
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
      ),
    );
  }
}