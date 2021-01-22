import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:fixme/Utils/utils.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:fixme/Model/BankInfo.dart';
import 'package:provider/provider.dart';
import 'package:fixme/Model/UserBankInfo.dart';
import 'Providers/BankProvider.dart';
import 'WalletWithdrawCompleteWithdrawal.dart';

class WalletWithdraw extends StatefulWidget {
  final UserBankInfo userBankInfo;

  WalletWithdraw({@required this.userBankInfo});

  @override
  _WalletWithdrawState createState() => _WalletWithdrawState();
}

class _WalletWithdrawState extends State<WalletWithdraw> {
  TextEditingController accountNo = new TextEditingController();
  TextEditingController searchBank = new TextEditingController();
  TextEditingController bankName = new TextEditingController();

  BorderRadiusGeometry radiusTop = BorderRadius.only(
    topLeft: Radius.circular(15.0),
    topRight: Radius.circular(15.0),
  );

  BorderRadiusGeometry radiusBottom = BorderRadius.only(
    bottomLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  );

  @override
  void dispose() {
    super.dispose();
  }

  showAppSelectionModal(BuildContext context) {
    var network = Provider.of<WebServices>(context, listen: false);
    var bankProvider = Provider.of<BankProvider>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetAnimationCurve: Curves.easeIn,
            insetAnimationDuration: Duration(milliseconds: 400),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 390,
                width: 120,
                child: ListView(
                  children: [
                    Container(
                      height: 55,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 12),
                      margin: const EdgeInsets.only(
                          bottom: 15, left: 12, right: 12, top: 15),
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          // border: isAppEmpty ? Border.all(color: Colors.red) : null,
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
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              FeatherIcons.search,
                              color: Color(0xFF555555),
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF270F33),
                                  fontWeight: FontWeight.w600),
                              controller: searchBank,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Search bank',
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
                      decoration: BoxDecoration(
                        color: Color(0xFF9B049B),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      height: 307,
                      child: FutureBuilder<List>(
                          future: network.getAvailableBanks(),
                          builder: (context, AsyncSnapshot<List> snapshot) {
                            Widget mainWidget;
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null) {
                                mainWidget = Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('No Network',
                                          style: TextStyle(
                                              // letterSpacing: 4,
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                );
                              } else {
                                // List _bankList = snapshot.data;
                                // List _searchList = _bankList;
                                //
                                // searchBank.addListener(() {
                                //   if (searchBank.text.isEmpty) {
                                //     print('I entered 2');
                                //     setState(() {
                                //       _searchList = _bankList;
                                //     });
                                //   } else {
                                //     print('I entered' + searchBank.value.text);
                                //     setState(() {
                                //       _searchList = [];
                                //       _bankList.forEach((element) {
                                //         if (element["name"] ==
                                //             searchBank.value.text) {
                                //           _searchList.add(element);
                                //         }
                                //       });
                                //     });
                                //   }
                                // });

                                mainWidget = ListView.separated(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 5),
                                    physics: BouncingScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    separatorBuilder: (context, position) =>
                                        Divider(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      BankInfo bankInfo = BankInfo.fromJson(
                                          snapshot.data[index]);
                                      return ListTile(
                                        onTap: () {
                                          bankName.text = bankInfo.name;
                                          bankProvider.setUserBankInfo =
                                              bankInfo;
                                          bankProvider.setBankNameStatus =
                                              false;
                                          Navigator.pop(context);
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: Color(0xFF270F33)
                                              .withOpacity(0.6),
                                          child: Text(
                                              bankInfo.name.substring(0, 1),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        title: Text(
                                          bankInfo.name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    });
                              }
                            } else {
                              mainWidget = Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Loading',
                                        style: TextStyle(
                                            // letterSpacing: 4,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              );
                            }

                            return mainWidget;
                          }),
                    ),
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var network = Provider.of<WebServices>(context, listen: false);
    return ChangeNotifierProvider<BankProvider>(
      create: (context) => BankProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(FeatherIcons.arrowLeft, color: Color(0xFF9B049B)),
          ),
          elevation: 0,
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: 140,
              margin: const EdgeInsets.only(top: 20, right: 5),
              alignment: Alignment.center,
              child: Image.asset('assets/images/fixme.png'),
            ),
            Row(
              children: [
                Container(
                  width: 20.0,
                  height: 40.0,
                  color: Colors.transparent,
                ),
                Text('Wallet Withdrawal',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w600))
              ],
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                    height: 55,
                    alignment: Alignment.centerLeft,
                    width: deviceSize.width,
                    decoration: BoxDecoration(
                      borderRadius: radiusTop,
                      color: Color(0xFFE6E7E8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.0,
                          height: 40.0,
                          color: Colors.transparent,
                        ),
                        Text('Transfer from:',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF333333),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: radiusBottom,
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFF1F1FD),
                            blurRadius: 15.0,
                            offset: Offset(0.3, 4.0))
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 7, bottom: 5),
                              child: Text(
                                  '${widget.userBankInfo.accountName}'
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 24,
                                      height: 1.4,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('\₦${widget.userBankInfo.balance}',
                                style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 24,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Account No: ',
                                  style: TextStyle(
                                      // letterSpacing: 4,
                                      color: Color(0xFF333333),
                                      fontSize: 21,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                  '***' +
                                      widget.userBankInfo.accountNumber
                                          .substring(6),
                                  style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: radiusTop,
                      color: Color(0xFFE6E7E8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.0,
                          height: 40.0,
                          color: Colors.transparent,
                        ),
                        Text('Transfer to:',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF333333),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: radiusBottom,
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFF1F1FD),
                            blurRadius: 15.0,
                            offset: Offset(0.3, 4.0))
                      ],
                    ),
                    child: Consumer<BankProvider>(
                        builder: (context, model, widget) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showAppSelectionModal(context);
                            },
                            child: AbsorbPointer(
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 15),
                                margin: const EdgeInsets.only(
                                    bottom: 3, left: 12, right: 12, top: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    border: model.getBankNameStatus
                                        ? Border.all(color: Colors.red)
                                        : Border.all(color: Color(0xFFF1F1FD)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xFFF1F1FD)
                                              .withOpacity(0.5),
                                          blurRadius: 10.0,
                                          offset: Offset(0.3, 4.0))
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF270F33),
                                            fontWeight: FontWeight.w600),
                                        controller: bankName,
                                        decoration: InputDecoration.collapsed(
                                          hintText: 'Select bank',
                                          hintStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                          focusColor: Color(0xFF2B1137),
                                          fillColor: Color(0xFF2B1137),
                                          hoverColor: Color(0xFF2B1137),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 13),
                                      child: Icon(
                                        FeatherIcons.arrowDown,
                                        color: Color(0xFF555555),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text('Account number',
                                    style: TextStyle(
                                        color: Color(0xFF4B4B4B),
                                        fontSize: 17,
                                        height: 1.4,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          Consumer<BankProvider>(
                              builder: (context, model, widget) {
                            return Container(
                              height: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(left: 17),
                              margin: const EdgeInsets.only(
                                  bottom: 6, left: 12, right: 12, top: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  border: model.getAccountNoStatus
                                      ? Border.all(color: Colors.red)
                                      : Border.all(color: Color(0xFFF1F1FD)),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xFFF1F1FD).withOpacity(0.5),
                                        blurRadius: 10.0,
                                        offset: Offset(0.3, 4.0))
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onChanged: (val) {
                                        model.setAccountNumber = val;
                                      },
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF270F33),
                                          fontWeight: FontWeight.w600),
                                      controller: accountNo,
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
                            );
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text('Choose beneficiary',
                                    style: TextStyle(
                                        color: Color(0xFF9B049B),
                                        fontSize: 16,
                                        height: 1.4,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
            Consumer<BankProvider>(builder: (context, model, widget) {
              return model.getIsValidated
                  ? Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                          top: 25, left: 15, right: 15, bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Color(0xFF9B049B),
                      ),
                      child: new FlatButton(
                        padding: EdgeInsets.all(10),
                        onPressed: () async {
                          if (bankName.text.isEmpty) {
                            model.setBankNameStatus = true;
                          } else if (model.getAccountNumber.isEmpty) {
                            model.setAccountNoStatus = true;
                          } else {
                            model.setIsValidated = false;
                            model.setAccountName =
                                await network.validateUserAccountName(
                                    accountNumber: model.getAccountNumber,
                                    bankCode: model.getUserBankInfo.code);
                            if (model.getAccountName.isNotEmpty) {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return WalletWithdrawCompleteWithdrawal(
                                        bankInfo: model.getUserBankInfo,
                                        accountName: model.getAccountName,
                                        accountNumber: model.getAccountNumber);
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
                            } else {}
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Confirm Receiver',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 25, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
