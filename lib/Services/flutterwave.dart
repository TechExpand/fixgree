import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:fixme/Services/Firebase_service.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({this.data});

  var data;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final narrationController = TextEditingController();
  final publicKeyController = TextEditingController();
  final encryptionKeyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedCurrency = "";

  @override
  Widget build(BuildContext context) {
    this.currencyController.text = this.selectedCurrency;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: this.formKey,
          child: ListView(
            children: <Widget>[
              Container(
                height: 140,
                margin: const EdgeInsets.only(top: 20, right: 5),
                alignment: Alignment.center,
                child: Image.asset('assets/images/fixme.png'),
              ),

              Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12),
                margin: const EdgeInsets.only(
                    bottom: 10, left: 12, right: 12, top: 5),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Color(0xFFF1F1FD)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFF1F1FD),
                          blurRadius: 15.0,
                          offset: Offset(0.3, 4.0))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                        value.isNotEmpty ? null : "Amount is required",
                        controller: this.amountController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardNumberInputFormatter()],
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF270F33),
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Amount',
                          hintStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          focusColor: Color(0xFF2B1137),
                          fillColor: Color(0xFF2B1137),
                          hoverColor: Color(0xFF2B1137),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12),
                margin: const EdgeInsets.only(
                    bottom: 10, left: 12, right: 12, top: 5),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Color(0xFFF1F1FD)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFF1F1FD),
                          blurRadius: 15.0,
                          offset: Offset(0.3, 4.0))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                        value.isNotEmpty ? null : "Email is required",
                        controller: this.emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF270F33),
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          focusColor: Color(0xFF2B1137),
                          fillColor: Color(0xFF2B1137),
                          hoverColor: Color(0xFF2B1137),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 12),
                margin: const EdgeInsets.only(
                    bottom: 10, left: 12, right: 12, top: 5),
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Color(0xFFF1F1FD)),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFF1F1FD),
                          blurRadius: 15.0,
                          offset: Offset(0.3, 4.0))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value) =>
                        value.isNotEmpty ? null : "Phone Number is required",
                        controller: this.phoneNumberController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardNumberInputFormatter()],
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF270F33),
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          focusColor: Color(0xFF2B1137),
                          fillColor: Color(0xFF2B1137),
                          hoverColor: Color(0xFF2B1137),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                margin:
                const EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Color(0xFF9B049B),
                ),
                child: new FlatButton(
                  padding: EdgeInsets.all(10),
                  onPressed:(){
                    if (formKey.currentState.validate()) {
                      this._handlePaymentInitialization();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Complete transaction',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  _handlePaymentInitialization() async {
    final flutterwave = Flutterwave.forUIPayment(
        amount: this.amountController.text.toString().trim(),
        currency: FlutterwaveCurrency.NGN,
        context: this.context,
        encryptionKey: "1c330246104c3fe9bf8fcccf",
        publicKey: "FLWPUBK-aaf6eae13f82933fed4440e8b2f6597a-X",
        email: this.emailController.text.trim(),
        fullName: "Fixme User",
        txRef: DateTime.now().toIso8601String(),
        narration: "Fixme Project",
        isDebugMode: true,
        phoneNumber: this.phoneNumberController.text.trim(),
        acceptAccountPayment: true,
        acceptCardPayment: true,
        acceptUSSDPayment: true);
    final response = await flutterwave.initializeForUiPayments();
   if(response.data.status == FlutterwaveConstants.SUCCESSFUL){
     WebServices network = Provider.of<WebServices>(context, listen: false);
     this.showLoading("Payment Successful");
     FirebaseApi.updateNotification(widget.data.id, 'confirm').then((value) {
       network.confirmBudget(widget.data.bidderId, widget.data.bidId, scaffoldKey);
     });
   }else if (response != null) {
      this.showLoading(response.data.status);
    } else {
      this.showLoading("No Response!");
    }
  }

  _handleCurrencyTap(String currency) {
    this.setState(() {
      this.selectedCurrency = currency;
      this.currencyController.text = currency;
    });
    Navigator.pop(this.context);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Center(child: Text(message)),
          ),
        );
      },
    );
  }
}
