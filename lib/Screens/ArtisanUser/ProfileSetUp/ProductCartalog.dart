import 'dart:io';

import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductCatelogPage extends StatefulWidget {
  final myPage;

  ProductCatelogPage(this.myPage);
  @override
  ProductCatelogPageState createState() => ProductCatelogPageState();
}

class ProductCatelogPageState extends State<ProductCatelogPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controlDes = TextEditingController();
   TextEditingController controlName = TextEditingController();
    TextEditingController controlPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WebServices network = Provider.of<WebServices>(context,  listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
    //Utils data = Provider.of<Utils>(context,  listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      body: WillPopScope(
        onWillPop: () {},
        child: Consumer<Utils>(
            builder: (context, conDatas, child) {
            return Container(
              padding: const EdgeInsets.only(right: 24, left: 24),
              child: ListView(
                shrinkWrap: true,
               physics: ScrollPhysics(),
               // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatefulBuilder(builder: (context, setState){
                    return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('Upload your product catalog',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Center(
                        child: SizedBox(
                          height: 100, // card height
                          child: conDatas.selectedImage2 == null
                              ? Text('')
                              : Container(
                            width: 100,
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.file(
                                  File(
                                    conDatas.selectedImage2.path,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ),
                      Material(
                        elevation: 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(26)),
                            child: FlatButton(
                              disabledColor: Colors.white,
                              onPressed: () {
                                conDatas.selectimage2(source: ImageSource.gallery).then((value){
                                  setState(() {
                                    print('j');
                                  });
                                });
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26)),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width / 1.3,
                                      minHeight: 45.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Select/Upload Product Photo",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    );
            }),
                  Container(
                    margin: EdgeInsets.only(bottom: 15, top: 28),
                    width: MediaQuery.of(context).size.width / 0.2,
                    height: 55,
                    child: TextFormField(
                      controller: controlName,
                      onChanged: (value) {
                        setState(() {
                          datas.setProductName(value);
                        });

                      },
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      maxLines: null,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: TextStyle(color: Colors.black38),
                        labelText: 'Product Name',
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
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    width: MediaQuery.of(context).size.width / 0.2,
                    height: 55,
                    child: TextFormField(
                      maxLines: null,
                      controller: controlPrice,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          datas.setProductPrice(value);
                        });

                      },
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: TextStyle(color: Colors.black38),
                        labelText: 'Product Price',
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
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    width: MediaQuery.of(context).size.width / 0.2,
                    height: 55,
                    child: TextFormField(
                      maxLines: null,
                      controller: controlDes,
                      onChanged: (value) {
                        setState(() {
                          datas.setProductBio(value);
                        });

                      },
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: TextStyle(color: Colors.black38),
                        labelText: 'Product Description',
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
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.height/3.5,
                  ),
    Consumer2<DataProvider,Utils >(
    builder: (context, conData,conData2 ,child) {
    return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
    child: Align(
                        alignment: Alignment.center,
                        child: !network.loginState
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(26)),
                                child: FlatButton(
                                  disabledColor: Color(0x909B049B),
                                  onPressed: conData.productBio.isEmpty ||
                                          conData.productPrice.isEmpty ||
                                          conData.productName.isEmpty ||
                                          conData2.selectedImage2 == null
                                      ? null
                                      : () {

                                          network.loginSetState();
                                          network.uploadProductCatalog(
                                            scaffoldKey: scaffoldKey,
                                            context: context,
                                            path: conDatas.selectedImage2.path,
                                            controlDes: controlDes.text,
                                            controlName: controlName.text,
                                            controlPrice: controlPrice.text,

                                          );
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
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26)),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.of(context).size.width / 1.3,
                                          minHeight: 45.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Upload",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 50.0, top: 20),
                                child: Theme(
                                                          data: Theme.of(context)
                                                              .copyWith(
                                                                  accentColor: Color(
                                                                      0xFF9B049B)),
                                                          child:
                                                          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),
                                                             strokeWidth: 2,
                                                    backgroundColor: Colors.white,
                                                          )),
                              )),
    );}),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
