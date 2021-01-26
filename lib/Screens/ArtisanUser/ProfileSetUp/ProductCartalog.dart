import 'dart:io';

import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Utils/Provider.dart';
import 'package:fixme/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fixme/Screens/ArtisanUser/Profile/ProfilePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductCatelogPage extends StatefulWidget {
  var myPage;

  ProductCatelogPage(this.myPage);
  @override
  ProductCatelogPageState createState() => ProductCatelogPageState();
}

class ProductCatelogPageState extends State<ProductCatelogPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    WebServices network = Provider.of<WebServices>(context);
    var datas = Provider.of<DataProvider>(context);
    Utils data = Provider.of<Utils>(context);
    return Scaffold(
      key: scaffoldKey,
      body: WillPopScope(
        onWillPop: (){},
        child: Container(
          padding: const EdgeInsets.only(right: 24, left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(top:15.0, bottom: 15),
                child: Text('Upload your product catalog', style: TextStyle(fontWeight: FontWeight.w500)),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 15),
                width: MediaQuery.of(context).size.width / 0.2,
                height: 55,
                child: TextFormField(
                  onChanged: (value) {
                    datas.setProductName(value);
                  },
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
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
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    datas.setProductPrice(value);
                  },
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
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
                  onChanged: (value) {
                    datas.setProductBio(value);
                  },
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
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
                Center(
                        child: SizedBox(
                          height: 100, // card height
                          child: data.selected_image2 ==null?Text(''):Container(
                            width: 100,
                            child:Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Image.file(File(data.selected_image2.path,), fit: BoxFit.cover,)

                            ),
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
                                  data.selectimage2(source: ImageSource.gallery);


                                  },
                            color:  Colors.white,
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
                                  "Select Catalog Photo",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                      ),
                        ),
                 ),
              Spacer(),
              Align(
                  alignment: Alignment.center,
                  child:  !network.login_state?Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(26)),
                    child: FlatButton(
                      disabledColor: Color(0x909B049B),
                      onPressed: datas.product_bio.isEmpty||datas.product_price.isEmpty||datas.product_name.isEmpty|| data.selected_image2 ==null?(){}:() {
                        network.Login_SetState();
                        network.uploadProductCatalog(
                          scaffoldKey: scaffoldKey,
                          context: context,
                            bio: datas.product_bio ,
                            product_name: datas.product_name,
                            price: datas.product_price,
                            path: data.selected_image2.path,
                        );

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
                            "Upload",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ):Padding(
                    padding: const EdgeInsets.only(bottom:50.0, top:20),
                    child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF9B049B)),),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}